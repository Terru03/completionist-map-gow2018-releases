"""Check Git page text sync without real Nexus credentials or uploads."""

import importlib.util
import json
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
import subprocess
import sys
import tempfile
import threading
import unittest
from unittest import mock

SCRIPT = Path(__file__).with_name('sync-nexus-description.py')


class DescriptionDryRunTests(unittest.TestCase):
    def test_dry_run_validates_committed_page_text_without_api_key(self):
        result = subprocess.run([sys.executable, str(SCRIPT), 'v1.0.9', '--dry-run'],
                                capture_output=True, text=True, timeout=10)
        self.assertEqual(result.returncode, 0, result.stderr)
        output = json.loads(result.stdout)
        self.assertTrue(output['dry_run'])
        self.assertEqual(output['version'], '1.0.9')
        self.assertEqual(len(output['description_sha256']), 64)


class DescriptionSyncTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        spec = importlib.util.spec_from_file_location('nexus_description_sync', SCRIPT)
        cls.sync = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(cls.sync)

    def setUp(self):
        temporary = tempfile.TemporaryDirectory()
        self.addCleanup(temporary.cleanup)
        self.root = Path(temporary.name)
        (self.root / 'docs').mkdir()
        self.summary = 'Completionist Map v1.0.9. No ReShade bundled.'
        self.description = '[b]Completionist Map v1.0.9[/b]\nKeep existing mods.\n'
        self.write_docs()
        self.state = {'mod': {'mod_id': 396, 'version': '1.0.9', 'summary': 'old', 'description': 'old'},
                      'versions': [{'id': '17622250816380', 'game_scoped_id': '891', 'version': '1.0.9',
                                    'category': 'main', 'is_primary': True}],
                      'patches': [], 'redirect': False, 'sink': 0, 'ignore_patch': False, 'deny': False}
        state = self.state

        class Handler(BaseHTTPRequestHandler):
            def log_message(self, *args):
                pass

            def reply(self, status, data=None):
                self.send_response(status)
                self.end_headers()
                if data is not None:
                    self.wfile.write(json.dumps(data).encode())

            def do_GET(self):
                if self.path == '/sink':
                    state['sink'] += 1
                    self.reply(200, {})
                elif state['deny']:
                    self.reply(403, {})
                elif self.path == '/v3/mod-files/8108382/versions':
                    if state['redirect']:
                        self.send_response(302)
                        self.send_header('Location', '/sink')
                        self.end_headers()
                    else:
                        self.reply(200, {'data': {'versions': state['versions']}})
                elif self.path == '/v1/games/godofwar/mods/396.json':
                    self.reply(200, state['mod'])
                else:
                    self.reply(404, {})

            def do_PATCH(self):
                body = json.loads(self.rfile.read(int(self.headers['Content-Length'])))
                state['patches'].append((self.path, body, self.headers.get('apikey')))
                if not state['ignore_patch']:
                    state['mod'].update(body)
                self.reply(204)

        server = ThreadingHTTPServer(('127.0.0.1', 0), Handler)
        thread = threading.Thread(target=server.serve_forever, daemon=True)
        thread.start()
        self.addCleanup(server.server_close)
        self.addCleanup(server.shutdown)
        origin = mock.patch.object(self.sync, 'API_ORIGIN', f'http://127.0.0.1:{server.server_port}')
        origin.start()
        self.addCleanup(origin.stop)
        delay = mock.patch.object(self.sync.time, 'sleep')
        delay.start()
        self.addCleanup(delay.stop)
        self.environment = {'NEXUSMODS_API_KEY': 'fake-test-key', 'NEXUSMODS_MOD_ID': '17622250815884',
                            'NEXUSMODS_FILE_ID': '8108382'}

    def write_docs(self):
        (self.root / 'docs/nexus-description-v1.0.9.short.txt').write_text(self.summary, encoding='utf-8')
        (self.root / 'docs/nexus-description-v1.0.9.bbcode.txt').write_text(self.description, encoding='utf-8')

    def run_sync(self):
        return self.sync.sync_description('v1.0.9', self.environment, self.root)

    def test_sync_changes_only_page_text_and_reads_it_back(self):
        result = self.run_sync()
        self.assertEqual(self.state['patches'], [('/v3/mods/17622250815884',
            {'summary': self.summary, 'description': self.description.strip()}, 'fake-test-key')])
        self.assertEqual(self.state['mod']['version'], '1.0.9')
        self.assertEqual(result['legacy_file_id'], '891')
        self.assertTrue(result['verified'])
        self.assertNotIn('fake-test-key', json.dumps(result))

    def test_repeat_sync_does_not_patch_unchanged_text(self):
        self.run_sync()
        self.run_sync()
        self.assertEqual(len(self.state['patches']), 1)

    def test_missing_version_stops_before_page_change(self):
        self.state['versions'] = []
        with self.assertRaises(ValueError):
            self.run_sync()
        self.assertEqual(self.state['patches'], [])

    def test_wrong_target_stops_before_page_change(self):
        self.environment['NEXUSMODS_MOD_ID'] = '999'
        with self.assertRaises(ValueError):
            self.run_sync()
        self.assertEqual(self.state['patches'], [])

    def test_old_release_cannot_replace_newer_page(self):
        self.state['mod']['version'] = '1.0.10'
        with self.assertRaises(ValueError):
            self.run_sync()
        self.assertEqual(self.state['patches'], [])

    def test_redirect_never_receives_api_key(self):
        self.state['redirect'] = True
        for operation in (self.run_sync, lambda: self.sync.make_client(self.environment).request(
                'GET', '/v3/mod-files/8108382/versions')):
            with self.assertRaisesRegex(RuntimeError, '302'):
                operation()
        self.assertEqual(self.state['sink'], 0)

    def test_failed_auth_does_not_expose_key(self):
        self.state['deny'] = True
        with self.assertRaises(RuntimeError) as error:
            self.run_sync()
        self.assertNotIn('fake-test-key', str(error.exception))
        self.assertEqual(self.state['patches'], [])

    def test_invalid_key_header_stops_without_exposing_value(self):
        self.environment['NEXUSMODS_API_KEY'] = 'fake\nprivate-value'
        with self.assertRaises(ValueError) as error:
            self.run_sync()
        self.assertNotIn('private-value', str(error.exception))
        self.assertEqual(self.state['patches'], [])

    def test_unpersisted_update_fails_verification(self):
        self.state['ignore_patch'] = True
        with self.assertRaisesRegex(RuntimeError, 'read-back'):
            self.run_sync()

    def test_bad_tag_or_blank_text_rejected(self):
        with self.assertRaises(ValueError):
            self.sync.prepare_payload(self.root, '../secret')
        self.summary = ' ' * 20
        self.write_docs()
        with self.assertRaises(ValueError):
            self.run_sync()
        self.assertEqual(self.state['patches'], [])


if __name__ == '__main__':
    unittest.main()
