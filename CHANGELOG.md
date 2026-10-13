# Changelog

## v1.0.5 — Universal Compatibility & Chest Tracking (2026-10-13)

- **Universal game compatibility:** Fully supports all God of War (2018) PC releases, including Steam, Epic Games, GOG, and non-official builds (CODEX, repacks, etc.).
- **Dynamic executable detection:** Removed hardcoded game version and hash locks from the native bridge runtime (`dxgi.dll`) and the installer (`Install.bat` / `install.ps1`). Executable checks are non-blocking.
- **Chest tracking fix retained:** Incorporates the player-verified v1.0.4 chest tracking fix in `mapmenu.lua` (SHA256: `89312da4a21d22bd651fe30ead5d45abddee6b318781fa9bd965315ada349787`), verifying inner owner ancestry so opened wooden and red/coffin chests disappear properly.
- **Zero regressions:** Retains Odin's Raven native authority tracking, real-time 3D compass waypoint clearing, and collectible state persistence.
- **Stability:** Retains Windows 10/11 compatibility layer protections to avoid early ntdll crashes.

[Release and ZIP](https://github.com/Terru03/completionist-map-gow2018-releases/releases/tag/v1.0.5). See [release notes and verification](releases/v1.0.5.md).

## v1.0.4 - Chest Tracking and Windows 10 Startup Fix (updated 2026-10-08)

- Fix opened wooden and red/coffin chest pins staying **Not collected** when the live scene omits outer catalogue ancestors. Check the inner chest-owner path against its exact placement before reading its opened state.
- Preserve duplicate-placement, duplicate-owner, wrong-path and save-change checks; an older save can restore an unopened chest's uncollected state.
- Promote the successful Discord chest test while keeping version **1.0.4**, all 20 installed payloads and all four installer files unchanged. Only release metadata and documentation change.
- The tester confirmed opened red/common chest pins disappear and killed Ravens are tracked correctly; the author relayed successful feedback on 2026-10-08. The startup reporter confirmed successful launch on 2026-10-06.
- Retain the early Windows 10/LTSC startup fix, deferred DXGI compatibility calls, live compass clearing, Artefact checks and Realm Tear completion tracking.

[Release and ZIP](https://github.com/Terru03/completionist-map-gow2018-releases/releases/tag/v1.0.4). See [release notes and verification](releases/v1.0.4.md).

## v1.0.2 — Test release

- Clears tracked compass target during gameplay when collected; no map reopen or checkpoint reload needed.
- Improves collected-state checks for all 45 Artefacts and completed sets.
- Improves Realm Tear state tracking across play, travel, and restarts.
- Includes v1.0.1 startup and installer checks.

[Test release and ZIP](https://github.com/Terru03/completionist-map-gow2018-releases/releases/tag/v1.0.2). Historical pre-release; superseded by v1.0.4.

## v1.0.1 — Stable

- Fixes startup when Windows DXGI exports differ or optional exports missing.
- Keeps graphics fallback when native compatibility checks fail; full mod still needs supported game EXE.
- Checks EXE, payload hashes, and boot JSON before installer changes game files.
- Supports Steam 1.0.13 / `GoW.exe` 1.0.475.7534.

[Stable release and ZIP](https://github.com/Terru03/completionist-map-gow2018-releases/releases/tag/v1.0.1).

## v1.0.0 — First public release

- Adds collectible world-map pins and compass targets with custom art.
- Adds map show/hide toggle, live target distance, and completion checks.
- Includes installer, uninstaller, and stock-file backups.

[Original release and ZIP](https://github.com/Terru03/completionist-map-gow2018-releases/releases/tag/v1.0.0).

Development prototypes and research history stay in private development repo.
