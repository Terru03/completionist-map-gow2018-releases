GOD OF WAR (2018) - COMPLETIONIST MAP v1.0.8
Released 2026-10-23

551 collectible marker records across 16 families, with map filters, custom
icons and compass tracking. Read-only completion tracking; no save edits.

WHAT CHANGED
- Fix save-load epoch drift which could leave Raven pins missing and chest
  tracking waiting forever. Use native bridge's confirmed epoch.
- Keep known Raven pins when other Raven states remain unknown.
- Let chest tracking run when Raven region totals cannot be resolved.
- Keep unknown Raven pins hidden; never guess mixed-group Raven identities.
- Retain bundled Script Loader/config, Caldera Hub trigger fix, marker filters,
  chest owner checks and Windows startup compatibility code.

QUICK START / UPDATE
1. Close God of War.
2. Extract CompletionistMap-v1.0.8.zip fully. Do not run inside ZIP.
3. Keep existing completionist_backup folder when updating.
4. Windows: run Install.bat. Select game folder if asked; allow UAC if needed.
5. Launch game. Open map. Load state may need a short refresh.

Installer checks package hashes, backs up affected files, installs missing
version.dll and loader_config.toml, then registers marker artwork.
Existing Script Loader preserved. No save-file conversion needed for update.

STEAM DECK / LINUX
Extract ZIP in Desktop Mode. Run:
  bash Install-SteamDeck.sh "/path/to/GodOfWar"
Steam Launch Options:
  WINEDLLOVERRIDES="dxgi,version=n,b" %command%

MANUAL / MOD MANAGER INSTALL
- Copy dxgi.dll, exec/ and mods/ into game root beside GoW.exe.
- If version.dll missing, copy prerequisites/version.dll into game root.
- Keep mods/loader_config.toml present with [Lua] LoadScripts = true.
- Back up exec/boot-options.json. Add this entry to existing patch-texpacks
  array; keep other entries:
  ../../patch/pc_le/completionist_v105_family_art
- Keep stock-file backups before manual or mod-manager deployment.

CONTROLS
- Open world map normally. Use native filters to choose marker families.
- Hover custom pin; press [Enter] / [E] to add, replace or remove compass target.
- Press [Down Arrow] in map to show/hide custom markers.
- Keep native Valkyries, gateways and shops; no duplicate custom pins for them.

NG / NG+ AND SAVE LOADS
- Both use same current-save tracking path. No save edits or migration.
- On load, discard old session evidence only after matching native capture.
- Unknown Raven pins stay hidden until exact state or unique constraints resolve.
- Last known Raven display may remain while load capture waits.

UNINSTALL
- Windows: run Uninstall.bat.
- Steam Deck / Linux: bash Uninstall-SteamDeck.sh "/path/to/GodOfWar"
- Manual/mod manager: restore stock files and original boot-options.json from
  backup, or use game launcher's file verification. Keep saves intact.

VERIFICATION AND LIMITS
- Automated save-load, sparse-state, package and installer regressions passed.
- Native authority, forwarding and startup fixture checks passed.
- Full package install, repeat install and rollback checked in temporary tree.
- Affected player NG/NG+ saves unavailable; live player validation still needed.
- Game build hash checks remain non-blocking. This is not proof every game
  build, device, Windows version or Proton setup works.
- Startup black-screen, ReShade and antivirus reports remain separate issues.
  v1.0.8 keeps v1.0.7 native DLLs. Another mod must not replace our dxgi.dll.
  No new antivirus clearance or claim all startup crashes resolved.

FAULT REPORTS
Include game build, Windows/Proton version, NG/NG+ state, exact area, chest
type and steps. Keep mods/completionist-map/native/raven-native-bridge.log.

DOWNLOADS / SUPPORT
https://github.com/Terru03/completionist-map-gow2018-releases/releases/tag/v1.0.8
https://www.nexusmods.com/godofwar/mods/396

Author: Terru03. Script Loader foundation: Nukem9.
