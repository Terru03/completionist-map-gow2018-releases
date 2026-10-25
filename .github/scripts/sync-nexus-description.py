"""Sync versioned Git page text through official Nexus API; no file upload."""

import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import time
import urllib.error
import urllib.request

ROOT = Path(__file__).resolve().parents[2]
API_ORIGIN = 'https://api.nexusmods.com'
MOD_ID = '17622250815884'
FILE_ID = '8108382'
MOD_PATH = '/v1/games/godofwar/mods/396.json'


def sha(text):
    return hashlib.sha256(text.encode('utf-8')).hexdigest()


def prepare_payload(root, tag):
    if not re.fullmatch(r'v[0-9]+\.[0-9]+\.[0-9]+', tag):
        raise ValueError('Stable release tag required.')
    summary = ' '.join((root / f'docs/nexus-description-{tag}.short.txt').read_text(encoding='utf-8-sig').split())
    description = (root / f'docs/nexus-description-{tag}.bbcode.txt').read_text(encoding='utf-8-sig').strip()
    if not summary or len(summary) > 350:
        raise ValueError('Page summary must contain 1-350 characters.')
    if not description or f'Completionist Map {tag}' not in description[:200]:
        raise ValueError('Page description must identify requested release.')
    return {'summary': summary, 'description': description}


class NoRedirect(urllib.request.HTTPRedirectHandler):
    def redirect_request(self, request, file, code, message, headers, new_url):
        return None


class NexusClient:
    def __init__(self, api_key):
        self.api_key = api_key
        self.opener = urllib.request.build_opener(NoRedirect())

    def request(self, method, path, payload=None):
        data = json.dumps(payload, ensure_ascii=False).encode('utf-8') if payload is not None else None
        request = urllib.request.Request(API_ORIGIN + path, method=method, data=data,
            headers={'apikey': self.api_key, 'Accept': 'application/json',
                     'Content-Type': 'application/json', 'Cache-Control': 'no-cache'})
        try:
            with self.opener.open(request, timeout=30) as response:
                data = response.read()
                return json.loads(data) if data else None
        except urllib.error.HTTPError as error:
            raise RuntimeError(f'Nexus API returned HTTP {error.code}.') from None
        except (urllib.error.URLError, json.JSONDecodeError):
            raise RuntimeError('Nexus API response unavailable or invalid.') from None


def page_matches(page, payload):
    return (' '.join(str(page.get('summary', '')).split()) == payload['summary'] and
            str(page.get('description', '')).replace('\r\n', '\n').strip() == payload['description'])


def sync_description(tag, environment, root=ROOT):
    payload = prepare_payload(root, tag)
    if environment.get('NEXUSMODS_MOD_ID', '').strip() != MOD_ID or environment.get('NEXUSMODS_FILE_ID', '').strip() != FILE_ID:
        raise ValueError('Nexus target must be Completionist Map mod 396 and its configured file.')
    key = environment.get('NEXUSMODS_API_KEY', '').strip()
    if not key:
        raise ValueError('NEXUSMODS_API_KEY missing.')
    if any(ord(character) < 33 or ord(character) > 126 for character in key):
        raise ValueError('NEXUSMODS_API_KEY contains invalid header characters.')
    client = NexusClient(key)
    versions = client.request('GET', f'/v3/mod-files/{FILE_ID}/versions')['data']['versions']
    matches = [version for version in versions if version['version'] == tag[1:]]
    if len(matches) != 1:
        raise ValueError('Exactly one existing Nexus file version required; no upload performed.')
    page = client.request('GET', MOD_PATH)
    if page.get('mod_id') != 396 or page.get('version') != tag[1:]:
        raise ValueError('Nexus page identity/version differs; no page text changed.')
    if not page_matches(page, payload):
        client.request('PATCH', f'/v3/mods/{MOD_ID}', payload)
        for attempt in range(3):
            page = client.request('GET', MOD_PATH)
            if page_matches(page, payload):
                break
            if attempt < 2:
                time.sleep(2)
        else:
            raise RuntimeError('Nexus page read-back did not match committed text.')
    return {'version': tag[1:], 'version_id': matches[0]['id'],
            'legacy_file_id': matches[0]['game_scoped_id'], 'verified': True,
            'summary_sha256': sha(payload['summary']), 'description_sha256': sha(payload['description'])}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('release_tag')
    parser.add_argument('--dry-run', action='store_true')
    args = parser.parse_args()
    if args.dry_run:
        payload = prepare_payload(ROOT, args.release_tag)
        result = {'version': args.release_tag[1:], 'dry_run': True,
                  'summary_sha256': sha(payload['summary']), 'description_sha256': sha(payload['description'])}
    else:
        result = sync_description(args.release_tag, os.environ)
    print(json.dumps(result, sort_keys=True))
    if not args.dry_run and os.environ.get('GITHUB_STEP_SUMMARY'):
        with Path(os.environ['GITHUB_STEP_SUMMARY']).open('a', encoding='utf-8') as output:
            output.write(f"\nPage summary and full description synced from Git and read back. Nexus file {result['legacy_file_id']}, version ID {result['version_id']}. No extra upload.\n")


if __name__ == '__main__':
    main()
