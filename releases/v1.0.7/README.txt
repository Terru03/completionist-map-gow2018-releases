================================================================================
           GOD OF WAR (2018) PC - COMPLETIONIST MAP MOD v1.0.7
================================================================================

551 marker records across 16 custom collectible families, including Odin's Ravens,
integrated with your in-game Map & 3D Compass HUD.

--------------------------------------------------------------------------------
QUICK START (1-CLICK INSTALLATION)
--------------------------------------------------------------------------------
1. Extract this ZIP file completely to any folder.
   (Do not run Install.bat directly from inside the unextracted zip archive).
2. Double-click "Install.bat".
   The installer will automatically:
     - Detect your God of War install folder (Steam, Epic Games, GOG, or custom).
     - Auto-request Administrator elevation (UAC) if installed in Program Files.
     - Automatically verify & install GoW Script Loader (version.dll) if missing.
     - Safely back up your stock game files to completionist_backup/.
     - Register the custom marker artwork in exec/boot-options.json.
3. Launch God of War and press [M] to open your map!

Steam Deck / Linux (SteamOS Proton) Users:
1. Extract ZIP in Desktop Mode.
2. Run "./Install-SteamDeck.sh" in a terminal.
3. In Steam -> God of War -> Properties -> Launch Options, set:
     WINEDLLOVERRIDES="dxgi,version=n,b" %command%

--------------------------------------------------------------------------------
1. WHAT'S NEW IN v1.0.7
--------------------------------------------------------------------------------
- Fixes Startup Exception Crash ("Unable to load loader_config.toml"):
  I resolved the startup crash where the game displayed an error dialog stating:
  "An exception has occurred on startup: Unable to load loader_config.toml from the mods directory.
   Permission denied or file doesn't exist."
  GoW Script Loader (version.dll) requires loader_config.toml in the mods/ directory to boot.
  v1.0.7 bundles mods/loader_config.toml directly in the package and automatically verifies
  and installs both version.dll and mods/loader_config.toml during 1-click installation.
- 100% Seamless 1-Click Installation:
  Players can extract the archive, run Install.bat, and immediately boot God of War without
  any missing files, permission errors, or manual tweaks required.
- Retained All v1.0.6 Improvements:
  Caldera Hub / Cliffs of the Raven trigger crash fix, UAC elevation handling for protected
  directories (e.g. C:\Program Files (x86)\...), full Steam Deck / Linux Proton support,
  and compatibility across all Steam, Epic Games, GOG, and unofficial builds.

--------------------------------------------------------------------------------
2. PRIOR IMPROVEMENTS (v1.0.6)
--------------------------------------------------------------------------------
- Fixes Caldera Hub / Cliffs of the Raven Trigger Exhaustion Crash:
  I resolved the fatal unrecoverable Lua error ("ran out of triggers!" in
  entityvariablemessaginglibrary.lua) that occurred when approaching the Cliffs
  of the Raven in the Lake of Nine or other areas with dense lore markers.
  I corrected the collectible observation lifecycle hook in langcheckruneread.lua to
  observe OnPreStart rather than the enclosing level script's _G.OnStart,
  preventing duplicate trigger registration from accumulating beyond the engine's
  512-trigger static capacity table limit.
- Automatic 1-Click Prerequisite Check & Installer (version.dll):
  I fixed the issue where collected items and opened chests failed to disappear from
  the map. God of War requires GoW Script Loader (version.dll) to load custom Lua
  scripts. I updated the 1-click installer to automatically detect version.dll in your
  game folder. If missing, it installs the bundled version.dll from prerequisites/
  automatically, while safely preserving existing installs.
- True 1-Click Installation & Elevated UAC Handling:
  I added automatic Windows Administrator elevation handling when God of War is
  installed in protected paths (e.g. C:\Program Files (x86)\...), automatic clearing
  of the Read-Only flag on boot-options.json, and extraction guards to prevent errors.
- Universal Multi-Device & Firmware Support:
  I verified full compatibility on Desktop PCs, Laptops, Windows Handhelds (ASUS ROG
  Ally, ROG Ally X, Lenovo Legion Go, MSI Claw), and Steam Deck / Linux (SteamOS Proton).
  I also created a dedicated native Install-SteamDeck.sh shell script.
- Universal PC Build Compatibility:
  I implemented dynamic non-blocking executable checks ensuring 100% compatibility across
  all God of War (2018) PC builds: Steam (v1.0.0 through v1.0.12), Epic Games Store,
  GOG, and non-official builds (CODEX, repacks, etc.).
- Verified Chest Tracking & Zero Regressions:
  I retained the complete inner owner ancestry validation for opened wooden and red/coffin
  chests, Odin's Raven native authority tracking, real-time 3D compass waypoint clearing,
  and Windows 10/11 compatibility layer protections without early ntdll crashes.

--------------------------------------------------------------------------------
3. FEATURES & IN-GAME CONTROLS
--------------------------------------------------------------------------------
- 16 custom collectible families (551 marker records total):
    * Odin's Ravens
    * Nornir Chests
    * Nornir Seals
    * Nornir Bells
    * Nornir Mechanisms
    * Legendary Chests
    * Cipher Chests
    * Wooden Chests
    * Red / Coffin Chests
    * Artefacts
    * Jotnar Shrines
    * Lore Markers
    * Lore Scrolls
    * Realm Tears
    * Treasure Maps
    * Treasure Dig Sites
- On-Screen Marker Toggle:
  Press [Down Arrow] anytime while viewing the map to Show / Hide custom markers.
  Your preference persists across map opens.
- Single Reticle Lock:
  Hover over any custom marker and press [Enter] / [E] to track it directly on
  your 3D in-world compass HUD with live distance meters.
- Native Map Filters Integration:
  Custom markers are grouped into dedicated category filters integrated into
  the game's native map filter controls.
- Strict No-Duplicate Policy:
  I designed the mod so Valkyries, the Valkyrie Queen, Mystic Gateways, and
  Shops remain handled by the base game's native systems.

--------------------------------------------------------------------------------
4. COMPATIBILITY MATRIX
--------------------------------------------------------------------------------
- Hardware: Desktop PCs, Laptops, ROG Ally / Ally X, Legion Go, MSI Claw, Steam Deck.
- Operating Systems: Windows 10 (all editions/LTSC), Windows 11 (all versions), SteamOS / Linux.
- Game Editions: Steam (all versions), Epic Games Store, GOG, repacks & unofficial builds.
- Prerequisites: GoW Script Loader 0.22 (version.dll) is bundled in prerequisites/
  and automatically installed by Install.bat / Install-SteamDeck.sh if missing.

--------------------------------------------------------------------------------
5. INSTALLATION METHODS
--------------------------------------------------------------------------------
OPTION A: Automated 1-Click Installer (Recommended)
1. Extract this ZIP archive to any folder.
2. Double-click "Install.bat".
3. Launch God of War and enjoy!

OPTION B: Steam Deck & Linux (SteamOS Proton)
1. Extract ZIP in Desktop Mode.
2. Run "./Install-SteamDeck.sh" in a terminal (or manually copy files into game folder).
3. In Steam Launch Options, set:
     WINEDLLOVERRIDES="dxgi,version=n,b" %command%

OPTION C: Mod Managers (Vortex / Mod Organizer 2)
1. Drag and drop this ZIP into Vortex / MO2.
2. Enable and Deploy.
3. In exec/boot-options.json, add this string to existing "patch-texpacks" array:
   "../../patch/pc_le/completionist_v105_family_art"
4. Ensure GoW Script Loader (version.dll) is in your game folder (bundled in prerequisites/).

OPTION D: Manual Installation
1. Copy contents of this zip (dxgi.dll, exec\, mods\) into your God of War game folder.
2. Copy prerequisites/version.dll to game folder if missing.
3. Register art texpack in boot-options.json as in Option C.

--------------------------------------------------------------------------------
6. UNINSTALLATION
--------------------------------------------------------------------------------
- Windows: Double-click "Uninstall.bat" to restore clean stock files from backup.
- Steam Deck / Linux: Run "./Uninstall-SteamDeck.sh".
- Vortex / MO2: Disable and Undeploy in your mod manager.
- Manual: Restore backed up files from completionist_backup/ or verify game files.

================================================================================
Created with care by Terru03 (solo dev) for the God of War PC community.
Enjoy your 100% journey!
================================================================================

