GOD OF WAR (2018) - COMPLETIONIST MAP v1.0.9
Released 2026-10-25

551 collectible marker records across 16 families, with map filters, custom
icons and compass tracking. Read-only completion tracking; no save edits.

QUICK START / UPDATE
1. Close God of War.
2. Fully extract CompletionistMap-v1.0.9.zip. Do not run inside ZIP.
3. Keep existing completionist_backup folder when updating.
4. Windows: run Install.bat. Select game folder if asked; allow UAC if needed.
5. Launch game. Open map. No save conversion needed.

Script Loader included. Existing loader kept. Shared settings kept; installer
enables Lua scripts when needed. No separate dependency steps for clean install.

EXISTING RESHADE / OTHER MODS (WINDOWS INSTALLER)
No ReShade, preset or shaders bundled. Mod does not require ReShade.
If ReShade already uses dxgi.dll, installer preserves it through d3d11.dll and
keeps our native dxgi.dll. ReShade.ini, preset and shader files stay untouched.
Verified ReShade backup from older install can be recovered automatically.
After ReShade install/update, rerun Install.bat if it replaced our dxgi.dll.

Unknown dxgi.dll, different occupied d3d11.dll or overlapping Lua/native/art
files stop install before payload writes. Error names conflicting path. Shared
config formats that cannot be merged safely also stop before payload writes.
game archives/map assets can need mod-specific merged patch. Installer cannot
merge arbitrary mods or guarantee every mod combination works.

On remove, keep other mods' later file changes, loader options and boot entries.
Original backup kept when changed file cannot safely be restored. Keep that
backup for recovery. Script Loader/config retained for other Lua mods.

WHAT CHANGED
- Preserve existing ReShade and shared Script Loader options on Windows.
- Check file conflicts, backup hashes and linked paths before relevant writes.
- Keep later mods' files and settings during removal.
- All 21 game payloads unchanged from v1.0.8, including native DLLs.
- Retain save-load epoch fix, known Raven states, independent chest tracking,
  Caldera Hub trigger fix and one-click bundled Script Loader.

CONTROLS
- Open world map normally. Use native filters to choose marker families.
- Hover custom pin; press [Enter] / [E] to add, replace or remove compass target.
- Press [Down Arrow] in map to show/hide custom markers.
- Native Valkyries, gateways and shops kept; no duplicate custom pins.

NG / NG+ AND SAVE LOADS
Both use same current-save path. No save edits or migration. Unknown Raven pins
stay hidden until exact evidence or unique constraints resolve. Last display
may remain while matching native load capture waits.

STEAM DECK / LINUX
Desktop Mode:
  bash Install-SteamDeck.sh "/path/to/GodOfWar"
Steam Launch Options:
  WINEDLLOVERRIDES="dxgi,version=n,b" %command%
These scripts retain previous behavior. New Windows compatibility safeguards
and automatic ReShade repair do not apply to Proton/manual installs. Back up
existing mods before use; do not overwrite another mod's DLL or shared config.

MANUAL / MOD MANAGER INSTALL
Use Windows Install.bat for automatic compatibility handling. For manual use:
- Back up changed files, shared config and exec/boot-options.json first.
- Copy dxgi.dll, exec/ and mods/ beside GoW.exe only after resolving overlaps.
- If version.dll missing, copy prerequisites/version.dll into game root.
- Merge [Lua] LoadScripts = true into existing mods/loader_config.toml.
- Add ../../patch/pc_le/completionist_v105_family_art to existing patch-texpacks
  array in exec/boot-options.json. Keep other entries.
- Retain backups. Never overwrite another mod's DLL or same-path script blindly.

UNINSTALL
Windows: Uninstall.bat. Keep reported recovery backups if other files changed.
Steam Deck/Linux: bash Uninstall-SteamDeck.sh "/path/to/GodOfWar".
Manual/mod manager: restore backed-up files and remove only our artwork entry
from current boot JSON, keeping other mods' edits. Keep saves intact.

VERIFICATION AND LIMITS
Real ReShade 6.8.0 DLL checked in temporary install/remove trees. Hardware D3D11
probe checked ReShade runtime creation. Full GoW + GOW REGRADE session not tested.
Affected player NG/NG+ saves unavailable. Game build hash checks non-blocking;
this does not prove every game build/device works. No universal mod compatibility
or new antivirus clearance claimed. Check Nexus file's current review state.

FAULT REPORTS
Include game build, Windows/Proton version, other installed mods, NG/NG+ state,
exact area and steps. Keep mods/completionist-map/native/raven-native-bridge.log.

DOWNLOADS / SUPPORT
https://github.com/Terru03/completionist-map-gow2018-releases/releases/tag/v1.0.9
https://www.nexusmods.com/godofwar/mods/396

Author: Terru03. Script Loader foundation: Nukem9.
