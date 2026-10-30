# Changelog

For the exhaustive numbered prototype list, including superseded and failed test builds, see [`docs/VERSION_HISTORY.md`](docs/VERSION_HISTORY.md).

## v1.1.0 - Nearby markers, bigger compass and safer install/uninstall (2026-10-30)

- Nearby markers: the nearest uncollected collectible of each family gets its
  compass marker and in-world icon, all families at once. `[Up Arrow]` on the
  world map cycles 50 m (start), 100 m, Off, 25 m; within 25 m the others show
  the game's white hint dot. Ravens and Nornir pieces count once the map would
  pin them; a killed Raven or opened Nornir chest drops its marker at once.
- Opened chests and other collected items update the map at once (each item's
  own state is passed to the map).
- `dxgi.dll` draws one in-world icon per family instead of the game's one
  (game version 1.0.13 from any store, DRM-free included: the game code and
  data it uses are checked byte for byte instead of the file's hash;
  `multi-icon.off` turns it off).
- Compass: 10 side markers instead of 6 (`compass-cap.off` keeps 6), one place
  always free for a marker you track, a distance on every marker on the bar,
  and a tracked favour the game leaves off (after a checkpoint load) is put
  back after about 4 s, with a 30 s wait if the game removes it again.
- 36 collectibles placed up to 186 m off (items in sub-groups of exported
  level prefabs) now sit on the item; story-moved items where they end up,
  elevator items at the top.
- Raven pins follow the selected map category; the `[Down Arrow]` Hide/Show
  prompt updates on every press.
- Tracked Completionist targets show their in-world icon from 100 m (game 20 m),
  adjustable globally and per family in `mods/completionist-map/settings.json`
  (Windows installer).
- Windows install/uninstall: `Install.bat` stops when run from inside the game
  folder; only the game's own files are backed up, Completionist copies in an
  old backup are dropped and the game files needing Steam's Verify are named;
  `Uninstall.bat` reads the install record in `completionist_backup` and
  removes every Completionist file by hash.
- Logs: `mods/loader_log.txt` is on by default (set once; a player's later
  `FileLogLevel = "off"` is kept; Uninstall turns it back off).
  `raven-native-bridge.log` rotates to `.previous.log` at 4 MB.
- README rewritten as a user guide with log and Discord support instructions.
- Steam Deck / Linux scripts unchanged (game's 20 m, no Windows checks).

## v1.0.9 - Windows mod compatibility and safe install/remove (2026-10-25)

- Preserve existing ReShade through D3D11; no ReShade/preset/shader bundling.
- Keep shared Script Loader settings; enable Lua without replacing other options.
- Reject unknown DLL and same-path Lua/native/art overlaps before payload writes.
- Preserve later mod edits and boot entries on remove. Verify originals; retain
  recovery backups when files changed after install.
- Keep every v1.0.8 game payload and native DLL unchanged.
- Windows installer change only. Full game/preset and Proton compatibility
  unverified; shared game archives may still need merged patches.

## v1.0.8 - Save-load, Raven and chest tracking fixes (2026-10-23)

- Use acknowledged native restore epoch across repeated load callbacks and loads
  without nearby Raven scripts. Retry failed boundary notes.
- Keep known Raven states usable while ambiguous or bonus states remain unknown.
  Unknown pins stay hidden; no mixed-group identity guesses.
- Restore independent chest-reader readiness when Raven totals unresolved.
- Retain all 21 game payloads from verified save-state candidate, including
  v1.0.7 native DLLs, game assets, Script Loader/config and installers.
- Update packaged/repository README, release notes, checksum and provenance.
- Offline regressions passed; affected player NG/NG+ validation still pending.
  Startup black-screen, ReShade and antivirus reports remain unresolved.

## v1.0.7 - Startup Loader Configuration Fix & Seamless 1-Click Install (2026-10-21)

- **Fixed Startup Exception Crash ("Unable to load loader_config.toml")**:
  - I resolved the crash on game launch where players on clean or fresh installations received an error dialog: `An exception has occurred on startup: Unable to load loader_config.toml from the mods directory. Permission denied or file doesn't exist.`
  - **Root Cause**: GoW Script Loader (`version.dll` by Nukem9) requires `mods/loader_config.toml` at startup to parse configuration options. Although `version.dll` was bundled in `prerequisites/` and installed automatically by `Install.bat` in v1.0.6, `mods/loader_config.toml` was omitted from the packaged ZIP, causing `version.dll` to abort initialization and crash `GoW.exe`.
  - **Resolution**: I added `mods/loader_config.toml` directly into the package payload and `prerequisites/` with safe, clean player defaults (`EnableDebugMenu = false`, `SkipIntroLogos = true`, `LoadScripts = true`, `FileLogLevel = "off"`).
  - I updated `scripts/install.ps1` and `Install-SteamDeck.sh` to automatically install and verify `mods/loader_config.toml` alongside `version.dll`.
- **Zero-Friction 1-Click Install**:
  - Players can extract the ZIP, run `Install.bat`, and immediately boot God of War with no missing files or manual intervention needed.
- **Retained All v1.0.6 Improvements (Zero Regressions)**:
  - Caldera Hub / Cliffs of the Raven trigger exhaustion fix (`OnPreStart` lifecycle hook in `langcheckruneread.lua`).
  - Windows UAC Administrator elevation for protected folders (`C:\Program Files (x86)\...`).
  - Full Steam Deck / Linux Proton support (`Install-SteamDeck.sh`).
  - Universal PC compatibility across Steam, Epic Games, GOG, and unofficial builds.
  - Verified chest tracking ancestry validation for opened wooden and red/coffin chests.
  - Odin's Raven native authority tracking and real-time 3D compass waypoint clearing.

## v1.0.6 - Caldera Hub / Cliffs of the Raven Trigger Exhaustion Fix & Universal Multi-Device Support (2026-10-15)

- **Automated Prerequisite Check & Installer (version.dll)**: I updated the 1-click installer to automatically check whether GoW Script Loader (`version.dll`) is present in the God of War game directory. If missing, it automatically installs the bundled `version.dll` from `prerequisites/`, ensuring loose Lua scripts load reliably and pins disappear from the map when collected.
- **Caldera Hub / Cliffs of the Raven Trigger Exhaustion Fix**: I fixed a fatal unrecoverable Lua error (`entityvariablemessaginglibrary.lua:216: ran out of triggers!`) that crashed the game when entering the Cliffs of the Raven in the Lake of Nine (`WAD_Cal100_Hub`) or other areas with dense lore markers.
  - **Root Cause**: The God of War engine has a fixed static capacity table limit of 512 triggers (`0x200`). Unlike chests, artefacts, and rifts, `langcheckruneread.lua` does not define `OnStart`. Its collectible observation wrapper previously tested `if type(OnStart) == "function"`, which resolved to the enclosing level script's `_G.OnStart` (`cal100_hub.lua:OnStart`). As each of the 26 rune markers loaded, it wrapped `_G.OnStart`, causing `cal100_hub.lua`'s `OnStart` to re-execute on each marker dispatch and accumulate over 512 entity variable monitors, crashing the Lua VM.
  - **Resolution**: I updated `langcheckruneread.lua` to observe `OnPreStart` (`if type(OnPreStart) == "function" then OnPreStart = wrap(OnPreStart) end`), leaving `_G.OnStart` untouched and allowing the level script to initialize exactly once (~30 triggers total).
- **Universal Multi-Device & Firmware Support**:
  - I verified full compatibility across Desktop PCs, Laptops, Windows Handhelds (ASUS ROG Ally, ROG Ally X, Lenovo Legion Go, MSI Claw), and Steam Deck / Linux (SteamOS Proton).
  - I added automated Windows UAC elevation if God of War is located in protected folders like `C:\Program Files (x86)\...`.
  - I added a dedicated Steam Deck / Linux shell installer (`Install-SteamDeck.sh` / `Uninstall-SteamDeck.sh`) and documented Proton launch options (`WINEDLLOVERRIDES="dxgi,version=n,b" %command%`).
  - I added a ZIP extraction guard in `Install.bat` / `Uninstall.bat` to detect and guide users attempting to run scripts directly from inside unextracted ZIP archives.
- **Universal PC Build Compatibility**: I retain full support across all God of War (2018) PC versions (Steam, Epic Games, GOG, and non-official builds/repacks).
- **Verified Chest Tracking**: I retain full inner owner ancestry checks for opened wooden and red/coffin chests with zero regressions.
- **Native Authority & Compass Clearing**: I retain Odin's Raven native authority tracking, real-time 3D in-world compass clearing, and Artefact/Realm Tear tracking.

## v1.0.5 - Universal PC Build Compatibility (2026-10-13)

- **Universal Game Build Compatibility**: I removed hardcoded executable version and hash checks from both the native bridge runtime (`dxgi.dll`) and installer (`Install.bat` / `install.ps1`), allowing all God of War (2018) PC releases (Steam, Epic Games, GOG, and non-official builds) to install and run smoothly.
- **Verified Chest Tracking**: I retained the player-verified v1.0.4 chest tracking fix validating inner owner ancestry so opened wooden and red/coffin chest pins correctly disappear.
- **Zero Regressions**: I retained Odin's Raven native authority tracking, real-time 3D compass waypoint clearing, Artefacts and Realm Tear completion authority.
- **Native Stability**: I retained Windows 10/11 compatibility layer protections without early ntdll crashes.
- **Native Map Category Filters**: I documented native map filter integration in the packaged README.

## v1.0.4 - Chest Tracking and Windows 10 Startup Fix (updated 2026-10-08)

- I promoted the Discord chest-tracking test to the production package while retaining version **1.0.4**. All 20 installed payloads and all four installer files are byte-for-byte identical to the tested ZIP.
- I fixed opened wooden and red/coffin chests staying marked **Not collected** when the loaded scene collapses catalogue ancestors outside the accepted chest placement. Validate the complete inner owner path against that exact placement so the opened state reaches map and compass tracking.
- I preserved duplicate-placement, duplicate-owner, wrong-inner-path and save-epoch checks; loading an older save with an unopened chest can restore its uncollected state.
- On 2026-10-08 I received successful feedback from the Discord tester. The tester confirmed that opened red/common chests disappear and killed Ravens are tracked correctly. This is one player's field result, alongside the offline regressions below.
- I retained the 2026-10-06 Windows 10 startup fix and the earlier Realm Tear, Artefact and live compass-clearing fixes:

- I handled `SetAppCompatStringPointer` before either proxy's static CRT initialization without allocating, loading DLLs, or starting native workers. Replay the original compatibility arguments when graphics initialization begins.
- I fixed the reproduced `ntdll` access violation from this early call. The supplied Windows 10 LTSC report has matching v1.0.1 DLL hashes and compatibility shims, but no crash stack; the reporting player confirmed successful startup on 2026-10-06.
- I added regressions for calls before CRT initialization and deferred compatibility argument replay in both native layers. Keep the supported EXE, companion hash, native instruction guards, and existing marker capacities.

## v1.0.3 - Real-Time In-World Compass Clearing & Full Artefact Authority Fix

- **Real-Time 3D In-World Compass Clearing**: Fixed player-tracked waypoint pins remaining active on the Compass HUD after collection/completion during live gameplay across all collectible families without requiring a save reload or reopening the map menu.
  - When collecting or completing an Artefact (`LuaHook_GiveLoot`), Realm Tear (`OnInteractFinish`), Chest (`OnOpened`), Jötnar Shrine (`UpdateJournal`), Treasure Dig (`UpdateQuest`), Lore Marker (`UpdateJournal`), or Lore/Treasure Scroll (`InteractComplete`), safely hides any active `"SIDE"` waypoint marker from `game.Compass` immediately.
  - Sends immediate `COMPLETIONIST_COLLECTIBLE_DIRTY_V1` hook dispatch to the UI VM, invoking `runtime:Poll()` to clean up tracked targets and synchronize direct observations in memory.
- **Full Artefact Direct Authority & Loaded Observation**: Fixed Artefact pins remaining visible on the 3D map menu after being collected.
  - Added native wallet resource tracking across all 45 Artefacts in `isDirectlyCollected()` (`collectible-location-map.lua`), handling multi-instance thresholds (e.g. `HornUShape`, `BroochRuby`, `HornHorse`, `ShipHook`) and category quest completion fallbacks (`Quest_Artifacts_*`).
  - Added `adapter == 'artefact'` support, owner fallback, and fast direct script lookup (`goartifactscript`) in `Loaded` reader (`collectible-loaded-reader.lua`).
  - Exported `GetState()` and `IsAcquired()` in `interact_loot_artifact.lua` to allow live loaded state extraction.

## v1.0.2 - Realm Tear Completion Authority Fix

- **Dual-Layer Realm Tear Completion Tracking**: Fixed Realm Tear markers not disappearing from the map after being completed and looted.
  - **Live Loaded Hierarchy & Adapter**: Updated `Loaded` module in `collectible-loaded-reader.lua` to recognize `adapter == 'rift'` (`hasOpened == true` / `GetState() == 4`), resolve rift interactive scripts (`gopocketrift_interact_loot`, `pocketrift_interact_loot`) through container parent hierarchies, and fall back to placement when owner matches are empty.
  - **Persistent Unloaded Authority**: Added `realm_tear` family handling in `isDirectlyCollected()` (`collectible-location-map.lua`) across all 21 Realm Tears mapping to their respective `RegionSummary_*_PocketRift_Parent` quests, silver rift labor quests, and Niflheim Trophy Tracker resources, ensuring completed tears stay hidden across map reopens, fast travels, and game restarts even when unloaded.
  - **Strict Read-Only Guarantee**: Maintained fail-closed observation architecture without progression writes or quest state modification.

## v1.0.1 - Startup Compatibility Fix (2026-10-04)

- Fix DXGI startup when optional Windows 11 export absent or export ordinals differ. Resolve system exports by name; optional exports no longer block graphics factories.
- Keep system graphics fallback when EXE or native DLL pair fails checks. Native patches stay disabled on unsupported builds; full mod still needs supported EXE.
- Installer checks EXE hash, all payload hashes, and boot JSON before backup or copy. Keep original backup and one art texpack entry on repeat install.
- Support pinned Steam 1.0.13 / GoW.exe 1.0.475.7534 only. Keep native hash and instruction guards. No change to Lua, map records, or art payloads from v1.0.0.
- Verified: 22 automated checks, Windows 10 export simulation, clean installer test, and two Windows 11 game launches with save loads. Save hash unchanged.
- Still needs player test: real Windows 10 launch and full map/compass controls. Reported PCs not yet retested; this release fixes reproduced startup defects, not proof every crash gone.

## v1.0.0 - Production Release

- **551 marker records across 16 custom collectible families**:
  - Odin's Ravens (53/54) with live native authority memory tracking (killed ravens never resurrect).
  - Nornir Chests (22) and Nornir puzzle sub-markers (66 seals, bells, mechanisms).
  - Legendary Chests (37 locations) with native read-only saved-state decoding.
  - Cipher Chests (14), Wooden Chests (99), Red / Coffin Chests (109).
  - Artefacts (45 across 7 sets), Jötnar Shrines (13), Lore Markers (43), Lore Scrolls (5).
  - Realm Tears (21), Treasure Maps (12), Treasure Dig Sites (12).
- **Strict No-Duplicate-Native-Marker Policy**: Preserves native handling for Valkyries, Valkyrie Queen, Mystic Gateways, and Shops to avoid duplicate pins.
- **Dedicated Compass HUD Art Pipeline**: 15 new `CompassIconClass` engine exports registered in `wad_r_perm.dcb` and `r_ui.wad`. Custom 2D HUD icons with live 3D bearing and distance readout in meters.
- **Map Controls**: On-screen `[Down Arrow]` show/hide toggle (persists across map reopens) and single-reticle `[Enter]` / `[E]` compass tracking with strict mutual exclusion.
- **Fog of War Support**: Custom markers render cleanly even in uncharted territory.
- **Read-Only Safety**: Fail-closed architecture without synthetic quest/save progression writes; save-epoch boundary resets prevent desyncs.
- **Universal 1-Click Installer**: Automated `Install.bat` / `Uninstall.bat` with multi-drive Steam/Epic auto-detection and stock backup support; Vortex/MO2 ready.

## v0.9.6.1-installer-fix

- Fixes an installer validation-order regression in v0.9.6.
- v0.9.6 checked for `PLAYER_HIDDEN_CENTER` before applying `$hiddenPlayerFocusRegex.Replace(...)`, so installation aborted even though the patch definition itself was valid.
- No gameplay, marker, filter, compass or lifecycle logic changes from v0.9.6.
- Retains `CursorSnap_Enabled=0`, `CursorSnap_Strength=0.0`, native-scale custom markers, stale-stock-compass clearing, hidden-Kratos opening centring, custom filters, Raven/Nornir lifecycle and `MaxIn=2.5`.
- Current test build: `Completionist-Map-v0.9.6.1-INSTALLER-FIX.zip`.

## v0.9.6-no-magnet-compass-fix

- v0.9.5.1 field result confirmed `PLAYER_HIDDEN_CENTER`, custom filters, Raven placement, Nornir parent/seal placement, distinct backing objects and Hide/Show Kratos are healthy.
- Diagnosed the v0.9.5 manual-hover experiment as invalid for selection: `MANUAL_HOVER_CURSOR` reported UI-local/root positions around `0,-40.222,0`, while custom map pins live around `x=3.x`, `z=0.x`.
- Because no `MANUAL_HOVER active=true`, `NORNIR_CHEST_COMPASS`, `NORNIR_COMPASS` or `CUSTOM_COMPASS` event fired, the observed `BOAT DOCK - The Mason's Channel` / ~683 m HUD destination was a stock DockPoint selection, not the Completionist target.
- Restores the field-proven v0.9.4 `UI.SetIsClickable()` + `MapCollisionChangeHandler` custom marker selection path.
- Disables map-camera magnetic attraction completely for the test build: `CursorSnap_Enabled=0`, `CursorSnap_Strength=0.0`.
- Restores custom map visuals to native backing scale `1.0`.
- Clears any currently tracked stock compass marker before enabling Raven/Nornir custom tracking, avoiding stale stock DockPoint HUD destinations.
- Retains the hidden-Kratos opening-centre fix and deep zoom `MaxIn=2.5`.
- Notes that the original Completionist icon source set is already present on `dev`; icon injection remains a separate next milestone after interaction/compass routing is stable.
- Initial field install did not complete because `PLAYER_HIDDEN_CENTER` was validated before its replacement ran. Superseded for testing by v0.9.6.1.

## v0.9.5.1-installer-fix

- Fixes another installer validation-order regression: v0.9.5 checked for `PLAYER_HIDDEN_CENTER` before applying the hidden-player-focus replacement.
- Field result: installation succeeds and hidden Kratos correctly keeps the map centred on the player when reopening (`PLAYER_HIDDEN_CENTER`).
- Field result also confirms filters, Raven and Nornir placement remain healthy.
- Field result rejects the manual-hover coordinate approach: the queried `MapCursor` world positions are not map-space positions, so the custom marker selection path never activates.

## v0.9.5-no-magnet-hover

- Field result from v0.9.4 confirmed Raven/Nornir target separation is fixed: Raven stayed at its immutable map coordinates while a Nornir chest was the active compass target.
- Field result also confirmed custom filters, Raven/Nornir positions, Hide/Show Kratos, seal/chest compass tracking and Nornir lifecycle remain healthy.
- Fixes hidden-Kratos reopening. Hiding `MapIconPlayer` no longer forces stock `SubmenuEnter()` to centre on `CALDERA_MAP_POSITION`; the hidden transformed player GO remains the opening camera focus.
- Restores synthetic marker visuals from temporary scale `0.28` to native backing scale `1.0`.
- Removes `UI.SetIsClickable()` from synthetic Completionist pins and attempts a manual `0.018` map-unit nearest-target hover path.
- **Field result:** the manual-hover approach cannot use `MapCursor:GetWorldPosition()` as map-space coordinates; no custom hover/compass selection event is produced. A nearby stock DockPoint can therefore be selected instead.
- Superseded by v0.9.6, which returns to native clickable collision but disables the map-camera snap magnet itself.

## v0.9.4-raven-snap-fix

- Field result from v0.9.3.1 confirmed the full map-side stack was healthy again: filters, Raven/Nornir pins, custom compass, Kratos toggle and real Nornir chest-open removal all worked.
- Fixes Raven/Nornir target interference. Raven map placement no longer reads the single shared active compass target's `mapX/mapZ`; it uses immutable Raven map coordinates instead.
- Adds `RAVEN_PIN_INDEPENDENT` diagnostic to prove Raven stays at its own map coordinate while a Nornir chest/seal is tracked.
- Replaces ineffective adaptive root scaling (`cursorScale=1`, `customIconScale=1` in field logs) with fixed synthetic root scale `0.28`.
- Reduces Nornir child selection latch from `120` to `12` frames.
- Tightens close-zoom snap further:
  - `CursorScale_Min: 0.12 -> 0.05`
  - `CursorSnap_Strength: 0.55 -> 0.18`
- Retains deep zoom `MaxIn=2.5`, distinct backing IDs, custom filters, seal Add-to-Compass and Hide/Show Kratos.
- Field result: Raven/Nornir target interference was fixed, but hidden Kratos caused fallback map centring and synthetic pins remained too magnetic at deep zoom. Scale `0.28` also made them visibly smaller than native markers.

## v0.9.3.1-map-load-hotfix

- Field result from v0.9.3 showed **no map-side Completionist startup at all**: `MAP_SCRIPT_LOADED`, `FILTER_MAPPING`, custom marker creation and `PLAYER_MARKER_TOGGLE` were all absent.
- Rebuilds from the field-proven compile-good v0.9.2 map patch instead of stacking more structural edits onto v0.9.3.
- Fixes the v0.9.2 adaptive-scale nil helper with the safe Lua pattern already used elsewhere: forward-declare `CompletionistMapV0931_ApplyZoomAdaptiveIconScale`, then assign its implementation later.
- Leaves the v0.9.2 Raven/Nornir marker loops structurally unchanged.
- Retains distinct discovered DockPoint backing IDs for Raven, Nornir parent and Nornir puzzle pins.
- Keeps deep map zoom at `MaxIn=2.5`.
- Reduces close-zoom snapping:
  - `CursorScale_Min: 0.50 -> 0.12`
  - `CursorSnap_Strength: 2.4 -> 0.55`
- Retains custom filters, seal Add-to-Compass and Hide/Show Kratos.
- Field result: successful recovery. `ALIAS_CHECK` reported distinct GameObjects, but Raven still moved to a Nornir target because its reinforcement used the shared compass-target coordinates. Snapping also remained too aggressive.

## v0.9.3-nornir-snap-fix

- Intended to fix the v0.9.2 marker-creation regression and tighten snapping.
- **Field regression:** map-side Completionist code did not initialise at all. The log contained gameplay/HUD instrumentation but no `MAP_SCRIPT_LOADED`, `FILTER_MAPPING`, custom markers or Kratos toggle.
- Superseded by v0.9.3.1, which is rebuilt from v0.9.2 rather than modifying the broken v0.9.3 map structure.

## v0.9.2-distinct-backings-snap

- Introduced a pool of distinct discovered Midgard DockPoint backing IDs rather than reusing one marker ID for all synthetic pins.
- Added `BACKING_POOL`, `BACKING_ASSIGN` and `ALIAS_CHECK` diagnostics.
- Attempted zoom-adaptive synthetic marker scaling.
- Field result: Raven remained visible, but Nornir parent/children disappeared because the scale helper resolved as a nil global during creation.

## v0.9.1-seal-compass-zoom-player

- Confirmed Nornir seal Add-to-Compass: `NORNIR_PROMPT -> NORNIR_COMPASS -> HUD_NORNIR_TRACK`.
- Gives puzzle children collision priority over their parent chest and keeps a short selection latch.
- Extends map zoom to `MaxIn=2.5`.
- Adds session-local Hide/Show Kratos map-marker toggle while preserving stock Go-to-Journal behaviour.

## v0.9.0.1-installer-fix

- Fixes v0.9.0 installer validation ordering. The milestone logic was valid, but the installer checked for the injected native-hover path before applying that injection.

## v0.9.0-nornir-lifecycle-native-hover

- Removes custom `Camera.PointAt()` marker hover recentering so custom hover preserves zoom.
- Uses the stock selected-cursor animation path.
- Reveals remaining Nornir puzzle siblings after the locked chest is attempted/restored as locked.
- Observes `interact_chest_standard.lua::OnOpened()` as the authoritative Runic chest-open event.
- Clears/removes the Nornir parent only after the real loot chest is opened.

## v0.8.7-nornir-compass-fix

- Fixes Lua lexical scope for `CompletionistMap...GetNornirRegistry` by forward-declaring the local helper before `IsTargetCollected()` captures it.

## v0.8.6-map-filter-fix

- Fixes the premature `end` in the v0.8.5 `MapOn:Update()` injection.
- Restores map-side Completionist loading, Raven/Nornir pins and custom filter mapping.
- Correctly omits persisted broken Breakable seals.

## v0.8.5-nornir-hierarchy-filters

- Introduces top-level Nornir chest parents versus child puzzle actors.
- Adds Completionist-specific logical filters into the existing bottom-left filter cycle.
- Field result: map-side injection failed because `MapOn:Update()` was closed early.

## v0.8.4-nornir-compass-zoom

- Removes a MainHUD call to a map-only Nornir registry helper.
- Tracks selected Nornir targets directly by copied world XYZ.
- Adds extended map zoom (`MaxIn 6 -> 3.5`).

## v0.8.3-nornir-registry-fix

- Fixes map/gameplay context isolation by adding a cross-context bridge and a verified-coordinate fallback for the known Breakable chest.
- Makes synthetic Nornir map pins independent of shared `_G` state for the tested chest.

## v0.8.2-nornir-map-hud

- First visible synthetic Nornir map/HUD prototype.
- Field result exposed that gameplay and map scripts did not share the assumed plain `_G` registry.

## v0.8.1-nornir-seal-state

- Adds exact `runeIndex` and individual rune visual-state diagnostics.
- Establishes persisted Breakable seal suppression semantics.

## v0.8.0-nornir-position-diagnostic

- Resolves `sealBreakable01..03` GameObjects to exact world XYZ for a real Breakable Nornir chest.

## v0.7.8-raven-lifecycle

- Raven milestone: map target led to a real remaining Raven.
- Killing the Raven cleared the custom HUD target and suppressed its later map marker.

## v0.7.x custom-HUD research

- Iterated away from unsafe synthetic native compass markers.
- Proved a HUD-native visual can be repositioned along the compass according to an arbitrary stored world XYZ bearing.
- See `docs/VERSION_HISTORY.md` for v0.7 through v0.7.7 individually.

## v0.6-api-transform-prototype

- Confirmed native marker records expose world-space `Coordinates`.
- Solved Midgard world-to-map transform:
  - `mapX = 0.004 * worldZ + 0.0625431`
  - `mapZ = -0.004 * worldX + 0.6101961`
- Maximum observed residual was approximately `1.2e-7` map units.

## v0.5.1-raven-registry-diagnostic

- Validates/deploys a pinned Raven gameplay-script reference when local source is missing.
- Confirms three Veithurgard Raven objects: two killed and one alive, matching the region summary.
- Captures exact remaining Raven world XYZ.

## v0.4-diagnostic

- Correlates realm/region completion summaries with hidden marker records.
- Rejects the native hidden-marker table as the direct collectible source.

## v0.3.1-diagnostic

- Uses incomplete Midgard against 100%-complete Alfheim as control.
- Proves `kUndiscovered` is dominated by infrastructure and is not a collectible state.

## v0.2-diagnostic

- Proves hidden marker records are exposed to Lua without rendering them.

## v0.1-test

- First hidden-marker rendering experiment.
- Opening the map crashed; direct rendering of arbitrary undiscovered native records was abandoned.
