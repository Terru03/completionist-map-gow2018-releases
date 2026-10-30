# Installation

## Before install

Use Windows 10 or 11, 64-bit. The mod works on God of War (2018) PC from any store, DRM-free copies included. The 10-marker compass, distances on the bar and one in-world icon per family need game version 1.0.13 (GoW.exe 1.0.475.7534); on other versions those stay off and everything else works.

GoW Script Loader & Gameplay Tweaks 0.22 (`version.dll` and `mods/loader_config.toml`) is bundled in `prerequisites/` and installed by `Install.bat` / `Install-SteamDeck.sh` if not already present.

Check the package SHA-256 against [SHA256SUMS.txt](SHA256SUMS.txt). In PowerShell:

```powershell
Get-FileHash -LiteralPath '.\CompletionistMap-v1.1.0.zip' -Algorithm SHA256
```

## One-click install (Windows)

1. Close God of War.
2. Download `CompletionistMap-v1.1.0.zip` from the [current release](https://github.com/Terru03/completionist-map-gow2018-releases/releases/tag/v1.1.0).
3. Extract it into its own folder **outside** the game folder, for example `Downloads\CompletionistMap-v1.1.0`. Do not extract it into the game folder; `Install.bat` refuses to run from there.
4. Run `Install.bat` from that folder. It finds the game folder (or asks), asks for administrator rights if the folder needs them, installs the Script Loader if missing, backs up the game files it replaces to `completionist_backup`, turns the mod log on and registers the artwork.
5. Start the game and open the map.

If you ever extracted the mod into the game folder or copied its files in by hand, first use Steam's *Verify integrity of game files* (or your launcher's equivalent).

## Updates

Close the game, extract the new ZIP to a new folder outside the game folder and run its `Install.bat`. Keep the `completionist_backup` folder in the game folder: it holds the game's own files. You do not need to uninstall first.

## Logs and problems

The main log, `mods/loader_log.txt`, is on by default and starts empty at every game start, so copy it before starting the game again. The native log is `mods/completionist-map/native/raven-native-bridge.log` (with `raven-native-bridge.previous.log`; the two stay at about 8 MB). To turn the main log off, set `FileLogLevel = "off"` in `mods/loader_config.toml`; later installs keep that. Send the logs, the area and what you did on the [Discord](https://discord.gg/URDc8uZmB).

## Steam Deck & Linux (Proton)

1. Extract `CompletionistMap-v1.1.0.zip` in Desktop Mode.
2. Run `bash Install-SteamDeck.sh "/path/to/GodOfWar"`.
3. In Steam Launch Options for God of War, set:
   ```text
   WINEDLLOVERRIDES="dxgi,version=n,b" %command%
   ```

These scripts copy files without the Windows checks (backups of only the game's own files, other mods, settings, the log default) and keep the game's 20 m in-world icon distance. Back up the game folder first. Not tested.

## Mod managers / manual install

1. Close the game. Back up the files you replace, `mods/loader_config.toml` and `exec/boot-options.json`.
2. Copy `dxgi.dll`, `exec/` and `mods/` from the ZIP beside `GoW.exe` (or deploy them with Vortex / Mod Organizer 2). Copy `prerequisites/version.dll` if it is missing.
3. In `mods/loader_config.toml`, set `[Lua] LoadScripts = true` (and `FileLogLevel = "info"` for the log).
4. In `exec/boot-options.json`, add this string to the existing `patch-texpacks` list, keeping all other entries:

   ```json
   "../../patch/pc_le/completionist_v105_family_art"
   ```

## Remove

- Installed with `Install.bat`: run `Uninstall.bat` from any extracted v1.1.0 or later package. It restores the backed-up game files, removes every Completionist file (also ones an earlier version left) and keeps your saves and `settings.json`. If it names game files with no backup, use Steam's *Verify integrity of game files* afterwards.
- Steam Deck / Linux: `bash Uninstall-SteamDeck.sh "/path/to/GodOfWar"`.
- Mod manager or manual: undeploy or restore your backups, and remove only the art entry from `exec/boot-options.json`.
