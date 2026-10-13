================================================================================
           GOD OF WAR (2018) PC - COMPLETIONIST MAP MOD v1.0.5
================================================================================

551 marker records across 16 custom collectible families, including Odin's Ravens,
integrated with your in-game Map & Compass.

--------------------------------------------------------------------------------
1. FEATURES
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
- Odin's Ravens use native completion authority within the same mod.
- No duplicate native markers: Valkyries, the Valkyrie Queen, Mystic Gateways
  and Shops remain handled by the base game's own map/compass systems.
- Custom Map Marker Artwork: Unique, lore-friendly icon for every collectible type.
- Custom Compass HUD Artwork: Full compass icons and distance tracking in 3D world.
- On-Screen Toggle: Press [Down Arrow] anytime on the map to Show/Hide markers.
  Your choice persists across map opens.
- Single Reticle Lock: Press [Enter] / [E] to pin any marker to the compass HUD.
- Read-only completion checks use live objects and native saved-state authority.

Native map filters
All custom markers are organized into dedicated collectible-category filters
integrated with the game's native map filters. Use the normal map filter
controls to focus on the marker types you want to see, such as Ravens,
chests or Artefacts. Related Nornir puzzle markers are grouped under the
Nornir Puzzle filter.

--------------------------------------------------------------------------------
2. REQUIREMENTS
--------------------------------------------------------------------------------
- Windows 10 or Windows 11, 64-bit.
- Compatible with all God of War (2018) PC releases (Steam, Epic Games, GOG,
  and non-official builds). Version checks are non-blocking.
- GoW Script Loader & Gameplay Tweaks 0.22 (version.dll) installed first.
- No other mod may replace dxgi.dll or these map files.

--------------------------------------------------------------------------------
3. INSTALLATION
--------------------------------------------------------------------------------
OPTION A: Automated 1-Click Installer (Recommended)
1. Extract this zip file anywhere.
2. Double-click "Install.bat".
   The installer automatically detects your God of War folder (Steam/Epic),
   backs up your original stock files, and installs the mod.
3. Launch God of War and open your map!

OPTION B: Mod Managers (Vortex / MO2)
1. Drag and drop this zip file into Vortex / Mod Organizer 2.
2. Enable and Deploy.
3. In exec/boot-options.json, add this string to existing "patch-texpacks" array:
   "../../patch/pc_le/completionist_v105_family_art"
   Keep all other entries. Back up JSON before edit.

OPTION C: Manual Installation
1. Copy the contents of this zip (dxgi.dll, exec\, mods\) into your God of War
   game folder (where GoW.exe is located).
2. Ensure GoW Script Loader 0.22 is installed.
3. Register art texpack in boot-options.json as in Option B.

--------------------------------------------------------------------------------
4. UNINSTALLATION
--------------------------------------------------------------------------------
- If you used the installer: Double-click "Uninstall.bat".
  It will restore your original stock files from backup and clean up mod files.
- If you installed via Vortex / MO2: Disable and Undeploy in your mod manager.
- If manual: Restore your backed-up files or verify file integrity via Steam/Epic.
- Vortex/manual: remove only mod's art texpack entry from boot-options.json.

--------------------------------------------------------------------------------
5. UPDATES IN v1.0.5
--------------------------------------------------------------------------------
- Universal compatibility for all God of War (2018) PC builds. Removes
  executable version restrictions in both the native bridge and installer so
  players across all releases and repacks can run the mod.
- Incorporates the tested v1.0.4 chest tracking fix: checks full inner owner path
  against the exact accepted placement for opened wooden and red/coffin chests
  so opened chest pins disappear immediately.
- Zero regressions: retains Odin's Raven native authority tracking, real-time
  3D in-world compass clearing, Artefacts and Realm Tear completion authority.
- Retains Windows 10/11 compatibility layer protections without early ntdll crashes.
- Installer verifies payload integrity and boot JSON before modifying game files.

================================================================================
Created with care for the God of War PC community. Enjoy your 100% journey!
================================================================================
