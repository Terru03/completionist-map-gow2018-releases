# Installation

## Before install

Use Windows 10 or 11, 64-bit. Compatible with all God of War (2018) PC versions: **Steam, Epic Games, GOG, and non-official builds (CODEX, repacks, etc.)**.

Install **GoW Script Loader & Gameplay Tweaks 0.22** (`version.dll`) first.

Check package SHA256 against [SHA256SUMS.txt](SHA256SUMS.txt). In PowerShell:

```powershell
Get-FileHash -LiteralPath '.\CompletionistMap-v1.0.5.zip' -Algorithm SHA256
```

## One-click install

1. Close God of War.
2. Download the full `CompletionistMap-v1.0.5.zip` from the [current release](https://github.com/Terru03/completionist-map-gow2018-releases/releases/tag/v1.0.5).
3. Extract ZIP to folder you can write to.
4. Run `Install.bat`. Installer finds game folder, checks payload hashes, backs up stock files to `completionist_backup`, then installs mod.
5. Keep backup folder and extracted installer files.
6. Launch game, then open map.

Keep mod's `dxgi.dll` in game folder. Avoid other mods that replace same DLL or map files. If install fails, copy exact error for support.

## Updates

Close game, extract new full release ZIP, then run its `Install.bat`. Keep original `completionist_backup`; do not delete backup to fix an install error. Use package's `README.txt` for version-specific steps.

## Mod managers

1. Close game. Back up affected files and `exec/boot-options.json`.
2. Add full release ZIP to Vortex or Mod Organizer 2, then enable and deploy.
3. In `exec/boot-options.json`, add this string to existing `patch-texpacks` array:

   ```json
   "../../patch/pc_le/completionist_v105_family_art"
   ```

4. Keep all other entries. Use valid JSON.

## Manual install

1. Close game. Back up affected files and `exec/boot-options.json` first.
2. Copy `dxgi.dll`, `exec/`, and `mods/` from release ZIP into game folder next to `GoW.exe`.
3. Ensure GoW Script Loader 0.22 installed.
4. Register art texpack in `exec/boot-options.json` as shown above.

## Remove mod

- If installed with `Install.bat`: run `Uninstall.bat`. It restores original files from `completionist_backup` and cleans up mod files.
- If mod manager: disable and undeploy in Vortex / MO2, and restore `exec/boot-options.json`.
- If manual: restore backups or verify file integrity via Steam/Epic.
