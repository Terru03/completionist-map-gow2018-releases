# Completionist Map for God of War (2018)

Current release: **[v1.0.8](https://github.com/Terru03/completionist-map-gow2018-releases/releases/tag/v1.0.8)** — save-load, Raven and chest tracking fixes.
[Download ZIP](https://github.com/Terru03/completionist-map-gow2018-releases/releases/download/v1.0.8/CompletionistMap-v1.0.8.zip) · [Nexus Mods](https://www.nexusmods.com/godofwar/mods/396?tab=files)

551 collectible marker records across 16 families, shown on in-game map and
compass with custom icons and native category filters. Completion tracking reads
game state; no save-file or progression edits.

## Changes in v1.0.8

- Fix restore epoch drift after repeated load callbacks or loads without nearby
  Raven scripts. Use confirmed native epoch for post-load captures.
- Keep known Raven states when other states unresolved. Unknown pins stay hidden;
  regional totals never guess identities in mixed groups.
- Let chest tracking run even when Raven region totals cannot be resolved.
- Retain v1.0.7 native DLLs, bundled Script Loader/config, installers, marker
  artwork, Caldera Hub trigger fix and earlier chest owner checks.

Nexus v1.0.8 upload complete; file quarantined by automated checks and download
blocked pending review. GitHub release published.

Offline regressions and package checks passed. Affected player NG/NG+ saves
unavailable; live player validation still needed. Startup black-screen, ReShade
and antivirus reports remain separate issues. No new scanner clearance claimed.

## Install or update

1. Close God of War. Fully extract `CompletionistMap-v1.0.8.zip`.
2. Keep existing `completionist_backup` folder when updating.
3. Windows: run `Install.bat`. Select game folder if asked; allow UAC if needed.
4. Launch game and open map. No save conversion needed.

Installer verifies payload hashes, backs up stock files, installs missing
`version.dll` and `mods/loader_config.toml`, then registers marker artwork.
Existing Script Loader preserved.

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

Windows 10/11 x64 and SteamOS/Linux through Proton are intended targets. Game
hash checks remain non-blocking across PC builds; this does not prove every
build, device or driver works. Keep our `dxgi.dll`; another mod using same DLL
name or map assets can conflict. ReShade conflict remains under investigation.

For faults: include game build, Windows/Proton version, NG/NG+ state, exact area,
chest type and steps. Keep
`mods/completionist-map/native/raven-native-bridge.log`.

## Remove

Windows: `Uninstall.bat`. Steam Deck/Linux:
`bash Uninstall-SteamDeck.sh "/path/to/GodOfWar"`.
Manual/mod-manager installs: restore stock files and original boot JSON from
backup, or use game launcher's file verification. Keep saves intact.

[Release notes and verification](releases/v1.0.8.md).
