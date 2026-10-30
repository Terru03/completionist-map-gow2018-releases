import hashlib
import json
import os
from pathlib import Path
import re
import sys
import uuid
import zipfile


def verify_release(tag, directory):
    if not re.fullmatch(r"v[0-9]+\.[0-9]+\.[0-9]+", tag):
        raise ValueError("A stable release tag such as v1.0.6 is required")
    version = tag[1:]
    basename = f"CompletionistMap-{tag}"
    filename = f"{basename}.zip"
    release = json.loads((directory / "release.json").read_text(encoding="utf-8"))
    if release["tagName"] != tag or release["isDraft"] or release["isPrerelease"]:
        raise ValueError("Only the requested published stable release can be uploaded")
    checksum = (directory / f"{basename}.sha256.txt").read_text(encoding="utf-8").strip().split(maxsplit=1)
    if len(checksum) != 2 or checksum[1].lstrip("*") != filename:
        raise ValueError("Checksum filename does not match the release ZIP")
    expected_hash = checksum[0].lower()
    if not re.fullmatch(r"[0-9a-f]{64}", expected_hash):
        raise ValueError("Invalid SHA-256 checksum")
    archive_path = directory / filename
    archive_bytes = archive_path.read_bytes()
    actual_hash = hashlib.sha256(archive_bytes).hexdigest()
    if actual_hash != expected_hash:
        raise ValueError("Release ZIP checksum mismatch")
    assets = [asset for asset in release["assets"] if asset["name"] == filename]
    if len(assets) != 1 or assets[0]["size"] != len(archive_bytes):
        raise ValueError("GitHub release asset size or identity mismatch")
    if assets[0].get("digest") != f"sha256:{actual_hash}":
        raise ValueError("GitHub release asset digest mismatch")
    provenance = json.loads((directory / f"{basename}.provenance.json").read_text(encoding="utf-8"))
    if (
        provenance["version"] != version
        or provenance["filename"] != filename
        or provenance["size"] != len(archive_bytes)
        or provenance["sha256"] != actual_hash
    ):
        raise ValueError("Release provenance does not match the archive")
    with zipfile.ZipFile(archive_path) as archive:
        names = archive.namelist()
        if len(names) != len(set(names)) or archive.testzip() is not None:
            raise ValueError("Release ZIP contains duplicate or corrupt entries")
        manifest = json.loads(archive.read("manifest.json"))
        if manifest["version"] != version or not manifest["files"]:
            raise ValueError("Package manifest version or payload list is invalid")
        if manifest["files"] != provenance["files"]:
            raise ValueError("Manifest payloads do not match release provenance")
        for relative, expected in manifest["files"].items():
            payload = archive.read(relative)
            if len(payload) != expected["size"] or hashlib.sha256(payload).hexdigest() != expected["sha256"]:
                raise ValueError(f"Package payload hash or size mismatch: {relative}")
    changelog = release["body"].strip()
    if not changelog:
        raise ValueError("Published release notes are required for the Nexus changelog")
    return {
        "filename": str(archive_path.resolve()),
        "version": version,
        "display_name": f"Completionist Map {tag}",
        "description": (
            f"Completionist Map {tag}. Complete package with Windows and Steam Deck installers. "
            "Close God of War, extract the ZIP to its own folder outside the game folder, run Install.bat "
            "from there, and keep completionist_backup. "
            "Release notes on GitHub."
        ),
        "changelog": changelog,
        "sha256": actual_hash,
    }


def main():
    if len(sys.argv) != 3:
        raise SystemExit("Usage: verify-nexus-release.py TAG RELEASE_DIRECTORY")
    outputs = verify_release(sys.argv[1], Path(sys.argv[2]))
    output_path = os.environ.get("GITHUB_OUTPUT")
    if output_path:
        with Path(output_path).open("a", encoding="utf-8") as output:
            for name, value in outputs.items():
                delimiter = f"nexus_{uuid.uuid4().hex}"
                output.write(f"{name}<<{delimiter}\n{value}\n{delimiter}\n")
    print(f"Verified Completionist Map {outputs['version']}: {outputs['sha256']}")


if __name__ == "__main__":
    main()
