# Installation

## Before install

Use Windows 10 or 11, 64-bit. Supported game is **Steam 1.0.13**, with `GoW.exe` file version **1.0.475.7534**.

Supported `GoW.exe` SHA256:

```text
caebcb027980d7eac9203d190f9ee649eebc549f8defce138e2114dc91f40452
```

Install **GoW Script Loader & Gameplay Tweaks 0.22** (`version.dll`) first. Other game EXE builds not supported. Full mod needs supported EXE even when graphics fallback lets game start.

Check package SHA256 against [SHA256SUMS.txt](SHA256SUMS.txt). In PowerShell:

```powershell
Get-FileHash -LiteralPath '.\CompletionistMap-v1.0.1.zip' -Algorithm SHA256
```

## One-click install

1. Close God of War.
2. Download full `CompletionistMap-v1.0.1.zip` from [stable release](https://github.com/Terru03/completionist-map-gow2018-releases/releases/latest). For test build, get `CompletionistMap-v1.0.2.zip` from [v1.0.2 pre-release](https://github.com/Terru03/completionist-map-gow2018-releases/releases/tag/v1.0.2).
3. Extract ZIP to folder you can write to.
4. Run `Install.bat`. Installer finds game folder, checks EXE and payload hashes, backs up stock files to `completionist_backup`, then installs mod.
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

Mod managers bypass installer checks. Check supported EXE hash yourself. See package's `README.txt` for full layout.

## Manual install

1. Close game. Back up affected files and `exec/boot-options.json` first.
2. Copy `dxgi.dll`, `exec/`, and `mods/` from release ZIP into game folder next to `GoW.exe`.
3. Ensure GoW Script Loader 0.22 installed.
4. Register art texpack in `exec/boot-options.json` as shown above.

Manual copy bypasses installer checks. Use supported EXE hash only.

## Remove mod

- Installer: close game, then run `Uninstall.bat`. Restores stock backup and removes mod files.
- Vortex / MO2: disable and undeploy mod.
- Manual: restore your stock backups, or verify game files through Steam / Epic.
- Vortex / manual: remove only mod's art texpack entry from `patch-texpacks`; keep other entries.

## Help

Post [GitHub issue](https://github.com/Terru03/completionist-map-gow2018-releases/issues) with mod version, Windows version, game build, install method, and exact error. Hide private paths and personal info in logs. Do not upload game files or saves.
