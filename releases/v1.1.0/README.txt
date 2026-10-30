GOD OF WAR (2018) - COMPLETIONIST MAP v1.1.0

Every collectible on the world map and compass: 551 markers across 16
families (Odin's Ravens, Nornir chests and their bells, seals and spinners,
legendary, cipher, wooden and red chests, artefacts, Jotnar shrines, lore
markers and scrolls, realm tears, treasure maps and dig sites), with custom
icons, map filters and compass tracking. Collected items drop off the map.
The mod only reads your progress: it never edits your save.

Questions, problems or ideas? Join the Discord: https://discord.gg/URDc8uZmB

CONTENTS
  1. Install
  2. Update from an earlier version
  3. Using the mod
  4. Settings
  5. Log files and reporting a problem
  6. Uninstall
  7. Other mods, ReShade and Steam Deck
  8. What changed in v1.1.0
  9. Known limits

------------------------------------------------------------------------------
1. INSTALL (WINDOWS)
------------------------------------------------------------------------------
1. Close God of War.
2. Extract CompletionistMap-v1.1.0.zip into its own new folder OUTSIDE the
   game folder, for example Downloads\CompletionistMap-v1.1.0.
   Do not extract it into the God of War folder, and do not copy its files
   there yourself: Install.bat copies them in and first backs up the game
   files they replace. (Install.bat stops, changing nothing, if it is run from
   inside the game folder.) Do not run Install.bat from inside the ZIP.
3. Run Install.bat from that folder. Select the game folder if asked, and
   allow the Windows administrator prompt if it appears.
4. Start the game and open the world map. No new save is needed.

The GoW Script Loader (version.dll) the mod needs is included and installed
for you if it is missing; an existing one is kept. The installer turns on Lua
scripts in mods\loader_config.toml and keeps your other settings there.

Already extracted the ZIP into the game folder, or copied the files in by
hand? Then the game files the mod replaces have no backup. In Steam, use God of
War > Properties > Installed Files > Verify integrity of game files, then
install as above. Install.bat names any game file it cannot back up for this
reason.

------------------------------------------------------------------------------
2. UPDATE FROM AN EARLIER VERSION
------------------------------------------------------------------------------
Close the game, extract the new ZIP to a new folder outside the game folder
and run its Install.bat. Keep the completionist_backup folder in the game
folder: it holds the game's own files. You do not need to uninstall first.
Install.bat recognises files from earlier Completionist versions and replaces
them; files another mod owns stop the install before anything changes.

------------------------------------------------------------------------------
3. USING THE MOD
------------------------------------------------------------------------------
World map
- Collectible pins show on the world map. Use the game's own map filters to
  choose which families to see; the Nornir bells, seals and spinners are
  under the Nornir Puzzle filter.
- Collected items, opened chests and killed Ravens drop off the map.
- [Down Arrow] on the map: hide or show all Completionist markers.
- Hover a pin and press [Enter] / [E]: add, replace or remove it as a compass
  target, as with the game's own markers.
- Valkyries, mystic gateways and shops keep the game's own markers; the mod
  adds no duplicates.

Nearby markers
- [Up Arrow] on the world map cycles the nearby range: 50 m (start), 100 m,
  Off, 25 m. The map footer shows it. It starts at 50 m each game start.
- Within the range, the nearest collectible of each family that the map does
  not show as collected gets that family's compass marker and in-world icon,
  all families at once.
- Odin's Ravens and Nornir chests, bells, seals and spinners count once the map
  would show their pin: a Raven whose state the map does not know yet, or a
  piece of a puzzle not yet revealed, is not marked.
- Within 25 m, the other collectibles show the game's small white hint dot.
- A family you track on the compass shows no nearby marker, and nearby markers
  are hidden while the world map is open.

Compass
- The compass bar holds 10 side markers instead of the game's 6 (game
  version 1.0.13; other versions keep 6). Tracked favours, gateways, shops and
  pins you track keep their place, and one place stays free for the next one
  you track; nearby markers fill the rest, nearest first.
- Every marker on the bar shows its distance. The game has 6 distance labels
  for side markers, so nearby markers past those are drawn in the world only.
- A favour you track stays on the compass: if the game leaves it off (for
  example after a checkpoint load), the mod puts it back after about 4
  seconds. If the game removes it again at once, the mod waits 30 seconds
  before trying again.
- The game draws only one in-world icon at a time; the mod draws one per
  family (game version 1.0.13 only).

New Game, New Game+ and loading saves work the same way. Raven pins whose
state the game has not reported yet stay hidden until it does.

------------------------------------------------------------------------------
4. SETTINGS
------------------------------------------------------------------------------
In-world icon distance (Windows installer)
The game shows a tracked target's floating icon only within 20 m; the mod uses
100 m for its own markers. To change it:
1. Copy settings.example.json to <GodOfWar>\mods\completionist-map\settings.json
2. Set "in_world_icon_distance_m" (5-500 metres), and optionally per family in
   "family_in_world_icon_distance_m". null = 100 m, 0 = the game's 20 m.
3. Run Install.bat again. It prints the distances it applied.
A missing file means 100 m; invalid values are listed and ignored. Only the
mod's own markers change. Your settings.json is never overwritten or deleted.
Before installing an older version, set 0 and run Install.bat, or uninstall
first.

Turning features off (create an empty file with this name)
- mods\completionist-map\native\compass-cap.off   keep the game's 6 compass
                                                   markers
- mods\completionist-map\native\multi-icon.off    keep the game's single
                                                   in-world icon
Delete the file to turn the feature back on.

------------------------------------------------------------------------------
5. LOG FILES AND REPORTING A PROBLEM
------------------------------------------------------------------------------
The mod writes two logs in the game folder. Both are plain text: open them
with Notepad.

mods\loader_log.txt  (the main log)
- Written by the Script Loader; Install.bat turns it on (FileLogLevel = "info"
  in mods\loader_config.toml). It holds what the map and markers do: lines
  starting [CompletionistProximity] and [CompletionistMap.
- It starts empty every time the game starts, so copy it BEFORE you start the
  game again. It grows by a few MB per hour of play.
- To turn it off, set FileLogLevel = "off" in mods\loader_config.toml. Install
  keeps your choice on later updates; set it back to "info" to turn it on.

mods\completionist-map\native\raven-native-bridge.log  (the native log)
- Always written. Lines starting COMPASS_CAP_GAME_ record the game's own
  compass markers (favours, story, shops) being shown, refused or hidden.
- When it reaches 4 MB (about 9 hours of play), during play or at game start,
  it is renamed to raven-native-bridge.previous.log (replacing the older one)
  and a new log starts, so the two together stay at about 8 MB.

To report a problem
1. When it happens, note where you are and what you did (or record a clip).
2. Close the game. Do not start it again before step 3.
3. Copy mods\loader_log.txt and
   mods\completionist-map\native\raven-native-bridge.log (and
   raven-native-bridge.previous.log if there is one).
4. Send them, with the area and steps, your game version (Steam, Epic or
   other), other mods you use, and New Game or New Game+, on the Discord:
   https://discord.gg/URDc8uZmB
   I am happy to go through problems with you there.

------------------------------------------------------------------------------
6. UNINSTALL
------------------------------------------------------------------------------
Windows: run Uninstall.bat from an extracted v1.1.0 package (this one or a
later one; the installer records what it installed in completionist_backup).
It puts back the backed-up game files, removes every Completionist file (also
ones an earlier version left), sets the log back to "off" if the installer
turned it on, and removes the art entry from exec\boot-options.json. The
Script Loader and its config stay for other Lua mods; your settings.json and
saves are kept. If another program changed a file since the install, that
file and its backup are kept for you to check. If Uninstall.bat names game
files with no backup (an earlier install replaced them without one), use
Steam's Verify integrity of game files afterwards.

------------------------------------------------------------------------------
7. OTHER MODS, RESHADE AND STEAM DECK
------------------------------------------------------------------------------
ReShade
No ReShade, preset or shaders are included, and the mod does not need it. If
ReShade already uses dxgi.dll, Install.bat keeps it working through d3d11.dll
and installs the mod's dxgi.dll. ReShade.ini, presets and shaders stay
untouched. After installing or updating ReShade, run Install.bat again if
ReShade replaced the mod's dxgi.dll.

Other mods
An unknown dxgi.dll, a different d3d11.dll, or Lua, native or art files
another mod owns stop the install before any game file changes; the error
names the file. Config files that cannot be merged safely stop it too. Mods
that change the same game archives or map data may need a merged patch; the
installer cannot merge arbitrary mods. On uninstall, other mods' later file
changes, loader options and boot entries are kept.

Manual / mod manager install
Use Install.bat where possible. Otherwise:
- Back up the files you replace, mods\loader_config.toml and
  exec\boot-options.json first.
- Copy dxgi.dll, exec\ and mods\ beside GoW.exe only after resolving overlaps.
- If version.dll is missing, copy prerequisites\version.dll beside GoW.exe.
- Merge [Lua] LoadScripts = true into mods\loader_config.toml (and set
  FileLogLevel = "info" there for the log).
- Add ../../patch/pc_le/completionist_v105_family_art to the patch-texpacks
  list in exec\boot-options.json, keeping other entries.
To remove: restore your backups and remove only that art entry.

Steam Deck / Linux
Desktop Mode:
  bash Install-SteamDeck.sh "/path/to/GodOfWar"
  bash Uninstall-SteamDeck.sh "/path/to/GodOfWar"
Steam Launch Options:
  WINEDLLOVERRIDES="dxgi,version=n,b" %command%
These scripts copy files and keep the game's 20 m in-world icon distance; they
have none of the Windows checks above (backups, ReShade, other mods, settings,
the log default). Back up the game folder and other mods first. Steam Deck and
Linux are not tested.

------------------------------------------------------------------------------
8. WHAT CHANGED IN v1.1.0
------------------------------------------------------------------------------
- Nearby markers: the nearest collectible of each family gets a compass
  marker and in-world icon, all families at once ([Up Arrow] picks the range).
- Opened chests and other collected items update the map at once; a killed
  Raven or opened Nornir chest drops its nearby marker without opening the map.
- Compass bar: 10 side markers instead of 6, every marker on the bar with a
  distance, and a tracked favour no longer stays off the compass.
- One in-world icon per family instead of one in total.
- 36 collectibles that sat off their real spot (up to 186 m), such as the beach
  maze artefact, cipher chest and dig site and the Nornir puzzles in Tyr's
  Vault, now have their pin, compass marker and icon on the item. Items the
  story moves (the ship head on Tyr's bridge, two rune lore markers in Alfheim)
  are placed where they end up; items on elevators where the elevator stops at
  the top.
- Odin's Raven pins follow the selected map filter like other families.
- [Down Arrow] Hide/Show Markers prompt updates on every press.
- Tracked markers' in-world icons from 100 m (adjustable, see Settings).
- Install and uninstall: backups hold only the game's own files, Install.bat
  stops if run from inside the game folder, Uninstall.bat no longer needs the
  matching package and removes every Completionist file, and the main log is
  on by default.

------------------------------------------------------------------------------
9. KNOWN LIMITS
------------------------------------------------------------------------------
- Odin's Ravens fly about; their markers are where they perch or start.
- The Jotnar shrine on the elevator in the middle of the Lake of Nine is
  marked where the elevator stops at the top, so the marker can float above
  the shrine.
- The 10-marker compass, distances on the bar and one icon per family need
  game version 1.0.13 (GoW.exe 1.0.475.7534, product version GoW-4757534),
  from any store, DRM-free copies included. dxgi.dll checks the game code and
  data it uses byte for byte before changing anything; on another game version
  these features stay off, the game keeps its own behaviour, and the native
  log says so (MULTI_ICON_REJECTED / COMPASS_CAP_REJECTED reason=bytes): please
  send it on the Discord so that version can be looked at.
- Tested in Windows game sessions on Steam. Marker positions were checked in
  game for the items a survey session reached (110 of 111 within 0.5 m); the
  rest were checked against the game files. Steam Deck / Linux, the full
  GoW + GOW REGRADE combination and every mod combination are not tested.
- No antivirus clearance is claimed for dxgi.dll; check the Nexus file's
  current review state.

------------------------------------------------------------------------------
Downloads: https://github.com/Terru03/completionist-map-gow2018-releases
           https://www.nexusmods.com/godofwar/mods/396
Discord:   https://discord.gg/URDc8uZmB
Author: Terru03. Script Loader: Nukem9.
