# Publishing GitHub releases to Nexus Mods

The prepared workflow uses the official [Nexus Mods upload action](https://github.com/Nexus-Mods/upload-action), pinned to `v1.0.0-beta.11`'s commit. Its automatic trigger is a newly published stable release in this downloads repository. The source repository must not also upload to Nexus, because both repositories publish the same package.

The workflow downloads the existing GitHub release ZIP, checksum, and provenance. It verifies the exact archive bytes and all manifest payloads, then uploads that ZIP without rebuilding or repacking it. The previous Nexus version is archived, the new file becomes the primary Main download, and the mod version and changelog are updated. Versioned Git files now also update the page summary and full BBCode description through the official Nexus API; no browser edit needed.

Page text comes from `docs/nexus-description-vX.Y.Z.short.txt` and
`docs/nexus-description-vX.Y.Z.bbcode.txt`. Text validates before upload. After
upload, sync uses `PATCH /v3/mods/{id}` with only `summary` and `description`,
then reads page text back through v1 and checks exact text, allowing v1's added
`<br />` display tags after newlines. This endpoint is
experimental in the [official schema](https://github.com/Nexus-Mods/Vortex/blob/master/packages/nexus-api-v3/schema/openapi.yaml)
(schema blob `a43fdf81df4b44b9af52587248ffbce2c824aec5` checked 2026-10-25).
Same repository secret used; key never enters logs or browser. Redirects rejected.

## One-time configuration

1. In the author's signed-in Nexus account, obtain a personal API key from [API access](https://www.nexusmods.com/settings/api-keys).
2. Store it as the `NEXUSMODS_API_KEY` GitHub Actions secret in this repository's [Actions settings](https://github.com/Terru03/completionist-map-gow2018-releases/settings/secrets/actions). Keep the key out of chat, commits, workflow inputs, and logs.
3. Set repository variables `NEXUSMODS_FILE_ID` and `NEXUSMODS_MOD_ID` using the IDs shown by the Nexus **Advanced** file controls or the Manage Files edit menu, as described by the official action. Use the API's identifiers; do not assume that legacy page-local file ID `884` or mod number `396` is the required API identifier.
4. Commit and push `.github/workflows/publish-nexus.yml`, `.github/scripts/verify-nexus-release.py`, and this guide to the downloads repository's default branch.

The personal key must belong to the mod author or an authorized mod-page team member. The current target is [Completionist Map, God of War mod 396](https://www.nexusmods.com/godofwar/mods/396).

## First run and existing releases

Use **Actions Ã¢â€ â€™ Publish release to Nexus Mods Ã¢â€ â€™ Run workflow** with `release_tag=v1.0.8` and `dry_run=true` first. This validates the published package without requiring Nexus credentials or uploading a file.

For an actual upload, set `dry_run=false`. The workflow checks Nexus's existing file versions before uploading and stops if the requested version already exists. If requested version already exists, inspect that file rather than creating duplicate upload. The guard also prevents a second upload if the first run created the file but subsequently failed while adding the changelog.

Future stable GitHub releases trigger automatically. Drafts, prereleases, and releases from forks do not upload. Publishing this workflow does not retrospectively trigger already published releases.

For page-text updates after a file already uploaded, dispatch with
`release_tag=v1.0.9`, `dry_run=false`, `description_only=true`. Exact GitHub
release package still verifies, but file upload and additive changelog are
skipped. Existing Nexus file/version and current page version must match.
Repeat sync skips unchanged text. No duplicate file or changelog entry created.
Keep `description_only=false` for normal release uploads.

## Review request

After upload, record the new Nexus file/version ID and verify its actual scan and download state. API upload completion does not establish malware-review approval or public download availability.

Email `support@nexusmods.com` from the author's Yahoo account tied to Nexus (never Gmail) with the mod link, exact new file link/ID, version, ZIP SHA-256, and public GitHub source/release links. Include the exact-hash VirusTotal result only when verified. Nexus's [quarantine guidance](https://help.nexusmods.com/article/117-why-has-my-mod-been-quarantined) requests a mod link and preservation of blocked files during review.

## Current setup and v1.0.6 review

v1.0.6 is publicly available on both GitHub repositories; its ZIP is 12,503,459 bytes with SHA-256 `4bd4abefdd7599ae38aa284bc57e31c86b2ce5d5f0af22623509f838c819f755`. The same archive was uploaded to Nexus as Main/primary file [885](https://www.nexusmods.com/godofwar/mods/396?tab=files&version_history=885). The mod version, file metadata, changelog, and detailed Windows/Steam Deck installation instructions were saved and reloaded; earlier files remain archived.

Repository variables are configured with the IDs copied from this new file's Advanced controls: `NEXUSMODS_FILE_ID=8108382` and `NEXUSMODS_MOD_ID=17622250815884`. `NEXUSMODS_API_KEY` is configured as an encrypted repository Actions secret. Its value must never appear in documentation, source, workflow inputs, screenshots, or logs.

At the 18 October 2026 check, Nexus quarantined this exact archive and public download was unavailable. The linked [exact-hash VirusTotal report](https://www.virustotal.com/gui/file/4bd4abefdd7599ae38aa284bc57e31c86b2ce5d5f0af22623509f838c819f755) showed 1/68 detections: MaxSecure, `Trojan.Malware.300983.susgen`. These results do not establish a clean scan or malware-review approval. A manual-review request was sent once from the author's Yahoo account and verified in Sent on 18 October 2026. Nexus support review remains pending.

The initial hosted `workflow_dispatch` run with `release_tag=v1.0.8` and `dry_run=true` [passed](https://github.com/Terru03/completionist-map-gow2018-releases/actions/runs/39143857475), verifying the published ZIP, checksum, GitHub digest, provenance, and manifest payloads. Its summary records the exact SHA-256 and confirms no Nexus upload occurred. No real authenticated automation upload was attempted because this version already exists on Nexus; that was the state at the v1.0.6 setup check. The authenticated v1.0.7 release-triggered [run](https://github.com/Terru03/completionist-map-gow2018-releases/actions/runs/39558018867) later completed verification and Nexus upload successfully.

## v1.0.8 release

Release date: 2026-10-23. Stable GitHub release triggers existing upload workflow.
ZIP, README, changelog, checksum and provenance updated. All 21 game payloads
match verified save-state candidate; v1.0.7 native binaries retained.

SHA-256: `540626ace11b33b610f6dfb6e327966013ad02f864e8c013efa11bab2d72c25b`.

Automatic workflow updates Main download, primary file, mod version and changelog.
Detailed mod description remains separate page edit; action has no such input.
Nexus scan/public download state must be read after upload. No malware-review
approval inferred from workflow success.

### v1.0.8 upload result

Release-triggered [run 39934673287](https://github.com/Terru03/completionist-map-gow2018-releases/actions/runs/39934673287)
passed on 23 October 2026. All verification, configuration and upload steps
succeeded. Uploaded API version ID: `17622250816378`; legacy Nexus file:
[890](https://www.nexusmods.com/godofwar/mods/396?tab=files&version_history=890).
Main download and mod header both read v1.0.8 after refresh.

Short and full descriptions saved separately from committed v1.0.8 text and
verified on public page. Automatic file checks then quarantined new file;
Nexus download blocked pending review. No support email sent by this release.

## v1.0.9 release

Windows installer compatibility and safe removal. ReShade/presets not bundled.
All 21 installed game payloads and native DLLs remain v1.0.8. Stable ZIP:
12,518,483 bytes, SHA-256
`e0a7f78f773860dd5e129c1ef83222969eb011fdb826f5361994c9f325249913`.

277 Python/Lua/real PowerShell/package checks, 13 native CTests and one hardware
D3D11/ReShade probe passed. Full GoW/preset and Proton migration unverified.
Release publication triggers existing workflow; page descriptions saved from
`docs/nexus-description-v1.0.9.*.txt`. Record upload/version ID and actual scan
state after workflow. No review approval inferred from upload success.
