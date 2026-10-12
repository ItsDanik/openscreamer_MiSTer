# OpenScreamer for MiSTer

Screamer on [MiSTer FPGA](https://github.com/MiSTer-devel/Main_MiSTer/wiki) as a hybrid core.

The game is [OpenScreamer](https://github.com/ItsDanik/openscreamer), a reimplementation of *Screamer* (Graffiti / Virgin Interactive, 1995, MS-DOS) written from the original program: the six tracks and their reversed versions, championship, time attack, cone carnage and slalom, replays and records. It runs on the MiSTer's ARM CPU. The OpenScreamer FPGA core provides native 15kHz video (CRT, VGA and HDMI) at 320x200, 320x240, 640x200 or 640x240, 44.1kHz audio, the music's FM chip (an OPL2, as in the sound cards the game was made for) and keyboard and gamepad input, with analog triggers and rumble. The two halves talk through shared DDR3 memory.

| | |
|---|---|
| ![A race in Palm Town, 320x200](docs/screenshots/race_palm_town_320x200.png) | ![The cockpit view](docs/screenshots/race_cockpit_320x200.png) |
| ![Lake Valley, 320x240](docs/screenshots/race_lake_valley_320x240.png) | ![Night race, 640x240](docs/screenshots/race_track4_night_640x240.png) |
| ![The starting grid, 640x240](docs/screenshots/race_grid_640x240.png) | ![Car selection, 640x200](docs/screenshots/menu_cars_640x200.png) |

More in [`docs/screenshots/`](docs/screenshots/): the game's own pictures in the core's four resolutions, as they are on a 4:3 screen.

> **Beta.** Expect rough edges and please report problems in the issues.

Disclaimer: AI is being used to speed up development of this project.

## Requirements

- **danik_hybrid_cores**, the launcher that comes in the release zip (`Scripts/danik_hybrid_cores.sh`): run it **once** from the MiSTer's `Scripts` menu. It starts the game whenever the core is loaded, keeps running after a reboot, and serves all our hybrid cores. Every hybrid core brings the launcher along and the newest version is the one that runs, so it never has to be run again after an update. Without it the core only shows the MiSTer logo.
- **Game data**, which is not included: the `DATA` and `GFX` folders of the original DOS game *Screamer* (1995). Tested with the retail CD version. The game is still sold; you need your own copy.

## Installation

1. Download the newest `OpenScreamer_YYYYMMDD.zip` from [releases](releases/) and extract it to the root of your SD card (`/media/fat`). That gives you:
   - `_Other/OpenScreamer_YYYYMMDD.rbf`, the FPGA core
   - `games/OpenScreamer/`, the game binary and its launcher
   - `Scripts/danik_hybrid_cores.sh`, the launcher (from [Hybrid_MiSTer](https://github.com/ItsDanik/Hybrid_MiSTer), which can also keep it up to date through `update_all`)
2. Copy the game's `DATA` and `GFX` folders, as they are, to `/media/fat/games/OpenScreamer/` (so that there is `/media/fat/games/OpenScreamer/DATA/GEN.DAT`, `.../GFX/GAME.DAT` and so on; upper or lower case does not matter). Nothing has to be unpacked. From `GFX` the six `MAP1H.DAT` .. `MAP6H.DAT` are not used and can be left out. The game's `CONFIG` folder is optional: if `CONFIG/CONTROLS.CFG` is there, its keyboard keys are used. Nothing else of the game is needed (no `.EXE`, no sound drivers).

   The game checks its data every time it starts; if a file is missing or damaged the log (below) says which.
3. Run **danik_hybrid_cores** from the `Scripts` menu, if you have not done so before (see Requirements).
4. Load **OpenScreamer** from the `Other` menu.

The game's log is in `/media/fat/logs/OpenScreamer/openscreamer.log`. Settings, best times, the championship, saved replays and time-attack ghosts are in `/media/fat/games/OpenScreamer/saves/` (`openscreamer.cfg`, `openscreamer.records`, `openscreamer.champ`, `openscreamer.replays/`, `openscreamer.ghosts/`); they are the port's own and not the DOS game's `CHOICE.DAT`. A new game has three tracks and twelve cars: the rest is won in the championship, as in the original.

## OSD options

| Option | |
|---|---|
| Aspect ratio, Scale, Scandoubler Fx, Stereo Mix | as in other cores |
| FPS Counter | shows the pictures per second in the top left corner |
| HDMI Only | **Yes** if no CRT is connected: resolutions of 640x400 and more are then progressive instead of interlaced, and the analog output is switched off while one is shown, so that a 15kHz screen can never get such a signal. Nothing changes at lower resolutions. Not needed with `forced_scandoubler=1` (VGA monitor); not there with `direct_video=1` |
| CRT Options | for a 15kHz screen: *Horizontal Size*, *Horizontal Pos* and *Vertical Pos* fit the picture to it. The pixels stay as they are; HDMI is not affected. Not there with `forced_scandoubler=1` |
| Resolution | **320x200** (default), the game's own; **320x240**: more of the road and sky above and below; **640x200** and **640x240**: twice as sharp across, with the game's high-resolution pictures for menus and instruments. Nothing is stretched (menus sit in the middle of a 240-row screen, the race's instruments at its edges). It changes at once, wherever you are. The 640 modes cannot reach 60 pictures a second (30 to 40): use *Lock to 30 FPS* with them |
| Lock to 30 FPS | Off (default) / On: a steady 30 pictures a second, for the 640 modes |
| Rumble | **Off** (default) / On / Strong: the controller shakes on wall hits, crashes, contact with other cars, grass, skids and wheelspin |
| Menu OK, Menu Back | the gamepad button that confirms / goes back in the game's menus, whatever it does in the game. **MiSTer** (default) uses the OK/Back buttons of your MiSTer menu |

## Controls

- **Keyboard** (the mouse is not used):

| Key | Action |
|---|---|
| Up / Down | accelerate / brake; in menus: choose a line |
| Left / Right | steer; in menus: change an option, the car, the track |
| Alt / Ctrl (or A / Z) | gear up / down, for cars with manual transmission |
| C | next view; F1 bumper, F2 cockpit, F3 near chase, F4 far chase |
| M | radar zoom (three sizes, off) |
| P | the CD player: choose the song, set the volumes |
| Backspace | puts the car back onto the road |
| Enter | confirm |
| Esc | back; in a race: leave (it asks first) |

  The six driving keys are those of the game's `CONFIG/CONTROLS.CFG` when that file is there. To change one, add a line to `saves/openscreamer.cfg`: `key_accelerate=`, `key_brake=`, `key_left=`, `key_right=`, `key_gear_up=` or `key_gear_down=` with a key's name, such as `key_brake=Space`.

- **Gamepad** (default mapping):

| Button | Action |
|---|---|
| Left stick | steer (analog); in menus: move |
| D-pad | steer; in menus: move |
| R2 / L2 (the triggers) | accelerate / brake, analog |
| A (Xbox B / PlayStation Circle) | accelerate |
| B (Xbox A / PlayStation Cross) | brake |
| X (Xbox Y / PlayStation Triangle) | radar zoom |
| Y (Xbox X / PlayStation Square) | next view |
| L (LB / L1) | gear down |
| R (RB / R1) | gear up |
| Select | back; in a race: leave (it asks first) |
| Start | confirm |

The triggers are read from the controller directly, not through MiSTer's button mapping, so they are not in *Define OpenScreamer buttons* and need a controller whose triggers are analog (Xbox, PlayStation and the like). Standing on the grid, an automatic car only takes first gear with the pedal nearly all the way down, as in the original. *Rumble* in the OSD is for controllers that have it.

Change the buttons in the OSD under *Define OpenScreamer buttons*. *Menu OK* and *Menu Back* there are only needed for a button without a game function; MiSTer doesn't let you assign a button twice, so to confirm with a button that also has a game function, pick it in the OSD's Menu OK/Menu Back options instead.

## Building

Everything builds in Docker on a Linux PC.

```sh
git clone --recursive https://github.com/ItsDanik/openscreamer_MiSTer.git
cd openscreamer_MiSTer
./build.sh              # ARM game binary  -> build/mister/openscreamer
./core/build_core.sh    # FPGA core (Quartus Lite 17.0.2) -> core/output_files/OpenScreamer.rbf
./package.sh            # release zip      -> dist/OpenScreamer_YYYYMMDD.zip
```

The toolchain image (Debian bullseye, glibc 2.31 to match the MiSTer) is built from `hybrid/toolchain/` on first use. The first build also downloads and builds SDL2, SDL2_mixer and SDL2_net.

### Repository layout

| Path | |
|---|---|
| `hybrid/` | submodule: [ItsDanik/Hybrid_MiSTer](https://github.com/ItsDanik/Hybrid_MiSTer), what all our hybrid cores share: the FPGA host module, the ARM side library, SDL2 drivers, the launcher (`danik_hybrid_cores.sh`), toolchain and conventions. See its README. |
| `core/` | FPGA core, based on [Template_MiSTer](https://github.com/MiSTer-devel/Template_MiSTer): `OpenScreamer.sv` (OSD and button names) around `hybrid/rtl/hybrid_host.sv` |
| `openscreamer/` | submodule: the game, branch `mister`, with the MiSTer changes |
| `package/` | files shipped in the release next to the binary (`danik_hybrid_launch.sh`, README) |
| `releases/` | release packages |

### Development notes

- `./build.sh host` builds the same game for the PC. It runs against `hybrid/tools/fakecore`, a stand-in for the FPGA core that takes scripted input and saves screenshots and audio:
  ```sh
  gcc -O2 -o build/host/fakecore hybrid/tools/fakecore.c
  build/host/fakecore /tmp/shm script.txt audio.raw &
  cd <data folder> && MISTER_HYBRID_SHM=/tmp/shm <repository>/build/host/openscreamer
  ```
- `touch /tmp/openscreamer_nolaunch` on the MiSTer keeps the core loaded without starting the game, so you can start a development binary by hand (set `MISTER_HYBRID_CORE=OpenScreamer`). `/tmp/danik_hybrid_cores.log` shows what the launcher daemon did.

## Support

If you enjoy this project, you can support my work on [Patreon](https://www.patreon.com/itsdanik).

## Credits

- **Screamer** (1995) by Graffiti, published by Virgin Interactive: the game this is all for.
- **[OpenScreamer](https://github.com/ItsDanik/openscreamer)**: the reimplementation, by Danik with Claude (Anthropic).
- **[JTOPL](https://github.com/jotego/jtopl)** by Jose Tejada (jotego): the FM chip in the FPGA. **[Nuked OPL3](https://github.com/nukeykt/Nuked-OPL3)** by Nuke.YKT: the same chip in software, for the PC build.
- **[SDL](https://libsdl.org)** by Sam Lantinga and contributors.
- **[MiSTer](https://github.com/MiSTer-devel)** by Sorgelig and the MiSTer-devel contributors: the framework and Template_MiSTer.
- **[MiSTer Frontier](https://github.com/MiSTerOrganize/MiSTer_Frontier)** by MiSTer Organize: thank you for the inspiration. Hybrid cores on the MiSTer, and the way their game is launched (a daemon that watches the loaded core and runs a script from its games folder), come from MiSTer Frontier. Our launcher is a separate implementation and does not need MiSTer Frontier installed.

This project and its maintainers are in no way associated with or endorsed by Milestone, Virgin Interactive or any other holder of rights in *Screamer*. It does not include any game data.

## License

The top-level scripts, tools and documentation are licensed under the [GPL-3.0](LICENSE). The components keep their own licenses: the shared framework in `hybrid/` is GPL-3.0 except where its files say otherwise, the game (`openscreamer/`) is GPL-3.0, Nuked OPL3 in it LGPL-2.1-or-later, JTOPL in `hybrid/rtl/jtopl` GPL-3.0, SDL and the SDL drivers in `hybrid/sdl2` are zlib, the FPGA core and the MiSTer framework are GPL-2.0 (`core/LICENSE`, with the core's own sources GPL-2.0-or-later).
