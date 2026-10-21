# Completionist Map for God of War (2018)

A PC mod for **God of War (2018)** that adds custom collectible markers to the game's world map and compass, with completion-aware behaviour designed for a full completionist playthrough.

Production build contains **551 marker records across 16 custom collectible families**. The current package is **[v1.0.7](https://github.com/Terru03/completionist-map-gow2018/releases/tag/v1.0.7)**, featuring the startup loader configuration fix (`mods/loader_config.toml`), the Caldera Hub / Cliffs of the Raven trigger exhaustion fix, universal PC compatibility across all God of War (2018) releases (Steam, Epic Games, GOG, and non-official builds like CODEX/repacks), the player-tested chest-tracking fix, and Windows 10/11 startup compatibility. [Download the release ZIP](https://github.com/Terru03/completionist-map-gow2018/releases/download/v1.0.7/CompletionistMap-v1.0.7.zip). [Nexus Mods](https://www.nexusmods.com/godofwar/mods/396?tab=files) is the mod page; scan and manual-review status are recorded in the [v1.0.7 release record](releases/v1.0.7.md).

## What it does

Completionist Map extends the native map and compass with custom markers for **16 collectible families**:

- Odin's Ravens
- Nornir Chests
- Nornir Seals
- Nornir Bells
- Nornir Mechanisms
- Legendary Chests
- Cipher Chests
- Wooden Chests
- Red / Coffin Chests
- Artefacts
- Jötnar Shrines
- Lore Markers
- Lore Scrolls
- Realm Tears
- Treasure Maps
- Treasure Dig Sites

All 16 families are part of Completionist Map. Some families use different internal completion-state sources where required by the game. For example, Odin's Ravens use their proven native authority path internally, but they are part of the same mod and the same completionist marker experience.

I follow a strict **no-duplicate-native-marker** policy. I do not add redundant Completionist Map pins for content that already has adequate native map and compass support, including **Valkyries, the Valkyrie Queen, Mystic Gateways and Shops**. Artwork for some native-only categories may exist in the repository's design/research asset pool, but those assets are not active custom marker families.

Markers added by Completionist Map use original, category-specific artwork designed to fit the God of War UI rather than reusing unrelated stock icons.

## Features

- 551 marker records across 16 custom collectible families
- Custom world-map markers across the production collectible catalogue
- Custom compass HUD icons with native-feeling direction and distance tracking
- Add, replace and remove compass-target behaviour
- Completion-aware marker handling so completed content can be hidden correctly
- Native/read-only authority paths for progression-sensitive collectible state
- Map filtering and marker visibility integration
- In-map marker show/hide control
- State handling across map reopen, reload and realm transitions
- Original marker artwork and texture-pack pipeline
- Automated installer and uninstaller with stock-file backup support

### Native map filters

All custom markers are organized into dedicated collectible-category filters integrated with the game's native map filters. Use the normal map filter controls to focus on the marker types you want to see, such as Ravens, chests or Artefacts. Related Nornir puzzle markers are grouped under the Nornir Puzzle filter.

I do not manufacture quest progress or mark collectibles complete for the player; every collectible must be earned legitimately.

## Release status

In v1.0.7, I fixed the startup crash ("Unable to load loader_config.toml from the mods directory") by bundling `mods/loader_config.toml` directly into the package and verifying its installation alongside `version.dll`.

In v1.0.6, I fixed the fatal Lua trigger exhaustion crash (`entityvariablemessaginglibrary.lua:216: ran out of triggers!`) that occurred when entering the Cliffs of the Raven in the Lake of Nine or other areas with dense lore markers, by switching the observation lifecycle hook in `langcheckruneread.lua` to `OnPreStart` instead of the enclosing level script's `_G.OnStart`.

I also retained universal PC build compatibility across all God of War (2018) PC releases (Steam, Epic Games, GOG, and non-official builds like CODEX/repacks), 100% of the proven v1.0.4 chest tracking fix (proper owner path ancestry validation for opened wooden and red/coffin chests), native Odin's Raven completion authority, real-time 3D in-world compass clearing, and Windows 10/11 compatibility layer protections with zero regressions. See the [v1.0.7 release record](releases/v1.0.7.md).

Older issues, research notes and archived probes remain in the repository as development history. They should not be interpreted as current release blockers.

## Installation

I built the release package around universal 1-click installation:

### Option A: Windows 1-Click Installer (PC & Handhelds)
1. Extract the release archive completely to any folder.
2. Close God of War.
3. Run `Install.bat`.
4. The installer automatically detects your game directory across Steam, Epic Games, GOG, and custom drives, requests UAC Administrator privileges if needed, verifies/installs GoW Script Loader (`version.dll`), backs up affected stock files to `completionist_backup/`, and registers the artwork patch.
5. Launch God of War and open the map.

### Option B: Steam Deck & Linux (SteamOS Proton)
1. Extract the ZIP in Desktop Mode.
2. Run `./Install-SteamDeck.sh` in a terminal (or copy the files into your game folder).
3. In the Steam client, right click **God of War** -> **Properties** -> **General** -> in **Launch Options**, set:
   ```text
   WINEDLLOVERRIDES="dxgi,version=n,b" %command%
   ```
   (This tells Proton/Wine to load the mod's native DLLs instead of built-in Wine DXGI).

### Uninstallation
- On Windows, double-click `Uninstall.bat`.
- On Steam Deck / Linux, run `./Uninstall-SteamDeck.sh`.
Original stock files are cleanly restored from `completionist_backup/` with zero residue.

Manual and mod-manager installs (Vortex / MO2) must register `../../patch/pc_le/completionist_v105_family_art` in existing `patch-texpacks` array in `exec/boot-options.json`, keeping all other entries.

## Compatibility & Requirements

- **Devices**: Desktop PCs, Laptops, Windows Handhelds (ASUS ROG Ally, ROG Ally X, Lenovo Legion Go, MSI Claw), and Steam Deck / Linux.
- **Operating Systems**: Windows 10 & 11 x64 (all editions/LTSC), SteamOS / Linux via Proton.
- **Game Releases**: Compatible with all God of War (2018) PC versions: Steam (v1.0.0 through v1.0.12), Epic Games Store, GOG, and non-official builds (e.g., CODEX, repacks). Game executable version checks are dynamic and non-blocking.
- **Prerequisites**: GoW Script Loader & Gameplay Tweaks 0.22 (`version.dll`) is bundled in `prerequisites/` and installed automatically by `Install.bat` / `Install-SteamDeck.sh` if missing. Other mods must not replace `dxgi.dll` or the same map assets.

## Using the mod

Open the world map normally. Completionist markers participate in the map UI alongside the game's own markers.

A collectible marker can be selected and tracked on the compass. The mod keeps the stock single-target behaviour: adding another destination replaces the active target, and the selected destination can be removed again from the map.

Completed collectibles are handled by the appropriate production completion source rather than by synthetic save/progression writes.

## Repository layout

This repository contains the mod's source patches, native bridge code, Lua runtime code, collectible catalogues, build and packaging tools, original marker artwork, tests, and the research trail used to reach the production implementation.

Important areas include:

- `native/` - native completion-state and runtime bridge code
- `tools/` - runtime, validation, packaging and installer tooling
- `catalogue/` - collectible catalogues and identity data
- `config/` - production collectible configuration
- `assets/` - original marker artwork and design sources
- `docs/` - implementation and research documentation
- `archive/` - historical field logs, probes and evidence

The large research archive is intentionally retained as provenance for the reverse-engineering and validation work behind the mod.

## Development history

The project began with a single Odin's Raven proof of concept, then expanded through full Raven tracking, Nornir support, individual collectible-family research and finally the unified production Completionist Map.

The current `main` branch represents the integrated production implementation. Historical prototype documents and closed issues may describe approaches that were later replaced.

## Safety philosophy

The mod was developed around a few strict rules:

- do not fabricate collectible completion
- do not write fake quest or region-summary progress
- prefer read-only observation of native game state
- fail closed when a progression state cannot be trusted
- preserve stock files through reversible installation and backup paths

## Nexus Mods

[Completionist Map on Nexus Mods](https://www.nexusmods.com/godofwar/mods/396). See the [v1.0.6 release record](docs/releases/v1.0.6-release.md) for the current file, scan result and manual-review request. A successful player test does not establish Nexus malware verification or download availability.

## License

No separate open-source or artwork reuse licence has been granted yet. Please ask before redistributing or reusing source code or original marker artwork.

