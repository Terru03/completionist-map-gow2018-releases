# Completionist Map for God of War (2018)

Current release: **[v1.1.0](https://github.com/Terru03/completionist-map-gow2018-releases/releases/tag/v1.1.0)** — nearby markers, a bigger compass and safer install/uninstall.
[Download ZIP](https://github.com/Terru03/completionist-map-gow2018-releases/releases/download/v1.1.0/CompletionistMap-v1.1.0.zip) · [Nexus Mods](https://www.nexusmods.com/godofwar/mods/396?tab=files) · [Discord](https://discord.gg/URDc8uZmB)

551 collectible markers across 16 families on the in-game map and compass,
with custom icons and the game's own map filters. Completion tracking reads
your progress; the mod never edits your save.

Families: Odin's Ravens; Nornir Chests, Seals, Bells and Mechanisms; Legendary,
Cipher, Wooden and Red/Coffin Chests; Artefacts; Jötnar Shrines; Lore Markers and
Scrolls; Realm Tears; Treasure Maps and Dig Sites.

## What's new in v1.1.0

- **Nearby markers:** the nearest uncollected item of each family gets a
  compass marker and in-world icon, all families at once. `[Up Arrow]` on the
  world map cycles 50 m / 100 m / Off / 25 m.
- **Compass:** 10 side markers instead of 6, a distance on every marker on the
  bar, and a tracked favour no longer drops off the compass.
- **One in-world icon per family** instead of one in total.
- **36 corrected positions:** items that sat up to 186 m off their real spot
  (beach maze, Tyr's Vault Nornir puzzles and others) now have their pin on
  the item.
- **Map:** collected items update at once; Raven pins follow the map filter;
  the `[Down Arrow]` prompt updates on every press; tracked icons from 100 m
  (adjustable).
- **Install and uninstall:** backups hold only the game's own files,
  `Install.bat` refuses to run from inside the game folder, `Uninstall.bat`
  works from any v1.1.0+ package and removes every Completionist file, and the
  main log is on by default for problem reports.

Full list: [CHANGELOG](CHANGELOG.md) ·
[release notes and verification](releases/v1.1.0.md).

## Install or update (Windows)

1. Close God of War.
2. Extract `CompletionistMap-v1.1.0.zip` into its own folder **outside** the
   game folder (for example `Downloads\CompletionistMap-v1.1.0`). Do not
   extract it into the game folder.
3. Run `Install.bat` from that folder. Select the game folder if asked; allow
   the administrator prompt if it appears.
4. Start the game and open the map. No new save needed.

Updating: run the new package's `Install.bat`; keep the `completionist_backup`
folder in the game folder. If you ever extracted the mod into the game folder
or copied its files in by hand, first use Steam's *Verify integrity of game
files*.

The bundled GoW Script Loader (`version.dll`) is installed if missing; an
existing one and your loader settings are kept. ReShade on `dxgi.dll` keeps
working through `d3d11.dll`. Files another mod owns stop the install before any
game file changes.

## Use

- World map: use the game's filters to choose families. `[Down Arrow]`
  hides/shows all Completionist markers; `[Up Arrow]` changes the nearby range.
- Hover a pin and press `[Enter]` / `[E]` to add, replace or remove it as a
  compass target.
- Valkyries, gateways and shops keep the game's own markers; no duplicates.
- Settings (in-world icon distance per family, turning the bigger compass or
  the extra icons off) are explained in the README inside the ZIP.

## Logs and problems

The main log, `mods/loader_log.txt`, is on by default and starts empty at every
game start, so copy it before starting the game again. The native log is
`mods/completionist-map/native/raven-native-bridge.log` (with
`raven-native-bridge.previous.log`; the two stay at about 8 MB). To turn the
main log off, set `FileLogLevel = "off"` in `mods/loader_config.toml`; later
installs keep that.

Send the logs, the area and what you did on the
[Discord](https://discord.gg/URDc8uZmB).

## Remove

Windows: run `Uninstall.bat` from any extracted v1.1.0 or later package. It
restores the backed-up game files and removes every Completionist file; your
saves and `settings.json` are kept.

Steam Deck / Linux (Desktop Mode): `bash Install-SteamDeck.sh "/path/to/GodOfWar"`
and `bash Uninstall-SteamDeck.sh "/path/to/GodOfWar"`, with Steam Launch Options
`WINEDLLOVERRIDES="dxgi,version=n,b" %command%`. These scripts copy files only,
without the Windows checks, and are not tested.

Tested in Windows game sessions on Steam. No antivirus clearance is claimed;
check the Nexus file's current review state.
