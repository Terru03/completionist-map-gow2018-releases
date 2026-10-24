# Completionist Map for God of War (2018)

Current release: **[v1.0.9](https://github.com/Terru03/completionist-map-gow2018-releases/releases/tag/v1.0.9)** — Windows mod compatibility and safe install/remove.
[Download ZIP](https://github.com/Terru03/completionist-map-gow2018-releases/releases/download/v1.0.9/CompletionistMap-v1.0.9.zip) · [Nexus Mods](https://www.nexusmods.com/godofwar/mods/396?tab=files)

551 collectible marker records across 16 families, shown on in-game map and
compass with custom icons and native category filters. Completion tracking reads
game state; no save-file or progression edits.

## Changes in v1.0.9

- Windows installer keeps existing ReShade through `d3d11.dll`; preset and
  shader files kept. ReShade and presets not bundled or required.
- Preserve shared Script Loader options; enable Lua scripts only when needed.
- Stop unsafe DLL and Lua/native/art overlaps before payload writes.
- On remove, keep later mods' file changes, loader options and boot entries;
  retain original backup when safe restore cannot be proved.
- Keep all 21 v1.0.8 game payloads, native DLLs, save-load Raven/chest fixes and
  bundled Script Loader. One-click install retained.

Nexus upload uses release workflow. Public availability depends on current
Nexus file review. No antivirus clearance claimed.

## Install or update

1. Close God of War. Fully extract `CompletionistMap-v1.0.9.zip`.
2. Keep existing `completionist_backup` folder when updating.
3. Windows: run `Install.bat`. Select game folder if asked; allow UAC if needed.
4. Launch game and open map. No save conversion needed.

Installer verifies payload hashes, backs up stock files, installs missing
`version.dll` and `mods/loader_config.toml`, then registers marker artwork.
Existing Script Loader and user options preserved. Lua enabled when needed.

Steam Deck / Linux, in Desktop Mode:

```sh
bash Install-SteamDeck.sh "/path/to/GodOfWar"
```

Steam Launch Options:

```text
WINEDLLOVERRIDES="dxgi,version=n,b" %command%
```

Manual and mod-manager installs: copy `dxgi.dll`, `exec/` and `mods/` beside
`GoW.exe`; copy `prerequisites/version.dll` if missing. Keep `mods/loader_config.toml`
with `[Lua] LoadScripts = true`. Back up `exec/boot-options.json`, then add
`../../patch/pc_le/completionist_v105_family_art` to existing `patch-texpacks`
array. Keep other entries and stock-file backups.

## Use

- Open world map normally. Use native filters to choose marker families.
- Hover custom pin; press `[Enter]` / `[E]` to add, replace or remove compass target.
- Press `[Down Arrow]` in map to show/hide custom markers.
- Native Valkyries, gateways and shops kept; no duplicate custom pins.
- Unknown Raven pins stay hidden. Prior Raven display may remain while matching
  load capture waits. NG and NG+ use same current-save path.

Families: Odin's Ravens; Nornir Chests, Seals, Bells and Mechanisms; Legendary,
Cipher, Wooden and Red/Coffin Chests; Artefacts; Jötnar Shrines; Lore Markers and
Scrolls; Realm Tears; Treasure Maps and Dig Sites.

## Compatibility and support

Windows automatic ReShade handling uses existing installed DLL only. If
ReShade setup/update replaces `dxgi.dll`, rerun `Install.bat`. Unknown DXGI,
occupied D3D11 and overlapping Lua/native/art files stop install safely.
Shared game archives/map assets still need mod-specific merged patches.
Arbitrary runtime compatibility cannot be proved by installer checks.

Real ReShade 6.8.0 checked in isolated Windows install/remove tests; hardware
D3D11 probe confirmed runtime creation. Full GoW + GOW REGRADE session untested.
Game hash checks non-blocking; this does not prove every game build/device works.
Steam Deck/Linux scripts retain prior behavior; new safeguards and automatic
ReShade repair apply only to Windows installer. Back up existing mods on Proton
or manual installs. Affected player NG/NG+ saves unavailable for live checks.

For faults: include game build, Windows/Proton version, NG/NG+ state, exact area,
chest type and steps. Keep
`mods/completionist-map/native/raven-native-bridge.log`.

## Remove

Windows: `Uninstall.bat`. Steam Deck/Linux:
`bash Uninstall-SteamDeck.sh "/path/to/GodOfWar"`.
Manual/mod-manager installs: restore stock files and original boot JSON from
backup, or use game launcher's file verification. Keep saves intact.

[Release notes and verification](releases/v1.0.9.md).
