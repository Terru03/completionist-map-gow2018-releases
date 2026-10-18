# Publishing GitHub releases to Nexus Mods

The prepared workflow uses the official [Nexus Mods upload action](https://github.com/Nexus-Mods/upload-action), pinned to `v1.0.0-beta.11`'s commit. Its automatic trigger is a newly published stable release in this downloads repository. The source repository must not also upload to Nexus, because both repositories publish the same package.

The workflow downloads the existing GitHub release ZIP, checksum, and provenance. It verifies the exact archive bytes and all manifest payloads, then uploads that ZIP without rebuilding or repacking it. The previous Nexus version is archived, the new file becomes the primary Main download, and the mod version and changelog are updated. The detailed mod description still requires a separate page edit.

## One-time configuration

1. In the author's signed-in Nexus account, obtain a personal API key from [API access](https://www.nexusmods.com/settings/api-keys).
2. Store it as the `NEXUSMODS_API_KEY` GitHub Actions secret in this repository's [Actions settings](https://github.com/Terru03/completionist-map-gow2018-releases/settings/secrets/actions). Keep the key out of chat, commits, workflow inputs, and logs.
3. Set repository variables `NEXUSMODS_FILE_ID` and `NEXUSMODS_MOD_ID` using the IDs shown by the Nexus **Advanced** file controls or the Manage Files edit menu, as described by the official action. Use the API's identifiers; do not assume that legacy page-local file ID `884` or mod number `396` is the required API identifier.
4. Commit and push `.github/workflows/publish-nexus.yml`, `.github/scripts/verify-nexus-release.py`, and this guide to the downloads repository's default branch.

The personal key must belong to the mod author or an authorized mod-page team member. The current target is [Completionist Map, God of War mod 396](https://www.nexusmods.com/godofwar/mods/396).

## First run and existing releases

Use **Actions → Publish release to Nexus Mods → Run workflow** with `release_tag=v1.0.6` and `dry_run=true` first. This validates the published package without requiring Nexus credentials or uploading a file.

For an actual upload, set `dry_run=false`. The workflow checks Nexus's existing file versions before uploading and stops if the requested version already exists. If v1.0.6 was uploaded manually, inspect that existing file rather than creating another v1.0.6 upload. The guard also prevents a second upload if the first run created the file but subsequently failed while adding the changelog.

Future stable GitHub releases trigger automatically. Drafts, prereleases, and releases from forks do not upload. Publishing this workflow does not retrospectively trigger already published releases.

## Review request

After upload, record the new Nexus file/version ID and verify its actual scan and download state. API upload completion does not establish malware-review approval or public download availability.

Email `support@nexusmods.com` from the author's Yahoo account tied to Nexus (never Gmail) with the mod link, exact new file link/ID, version, ZIP SHA-256, and public GitHub source/release links. Include the exact-hash VirusTotal result only when verified. Nexus's [quarantine guidance](https://help.nexusmods.com/article/117-why-has-my-mod-been-quarantined) requests a mod link and preservation of blocked files during review.

## Current setup and v1.0.6 review

v1.0.6 is publicly available on both GitHub repositories; its ZIP is 12,503,459 bytes with SHA-256 `4bd4abefdd7599ae38aa284bc57e31c86b2ce5d5f0af22623509f838c819f755`. The same archive was uploaded to Nexus as Main/primary file [885](https://www.nexusmods.com/godofwar/mods/396?tab=files&version_history=885). The mod version, file metadata, changelog, and detailed Windows/Steam Deck installation instructions were saved and reloaded; earlier files remain archived.

Repository variables are configured with the IDs copied from this new file's Advanced controls: `NEXUSMODS_FILE_ID=8108382` and `NEXUSMODS_MOD_ID=17622250815884`. The personal API key belongs only in the repository Actions secret; its value must never appear here or in logs.

At the 18 October 2026 check, Nexus quarantined this exact archive and public download was unavailable. The linked [exact-hash VirusTotal report](https://www.virustotal.com/gui/file/4bd4abefdd7599ae38aa284bc57e31c86b2ce5d5f0af22623509f838c819f755) showed 1/68 detections: MaxSecure, `Trojan.Malware.300983.susgen`. These results do not establish a clean scan or malware-review approval. A Yahoo manual-review request follows the workflow setup.
