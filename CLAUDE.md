# OpenScreamer hybrid core for MiSTer (Screamer)

@hybrid/CLAUDE.md

## This core

- Name everywhere: `OpenScreamer` (core, folders, release), `openscreamer` (game submodule, binary in `build/`, log, lock).
- The game is the `openscreamer/` submodule, branch `mister`. Its MiSTer code is behind the `MISTER_HYBRID` build option.
- Build: `./build.sh` (game), `./core/build_core.sh` (FPGA), `./package.sh` (zip in `dist/`), `MISTER=root@<address> tools/deploy.sh`.
- Lines marked `GAME:` in the scripts and `TODO` in the READMEs are the places the template left for this game.

<!-- Notes that are only true for this game go below. -->

## This game

- The game's own repository is `~/openscreamer` (`ItsDanik/openscreamer`, branch `main`, the PC version; its `CLAUDE.md` is the long record of the reverse engineering). Do no MiSTer work there. The submodule here is its branch `mister`: x86 work arrives by `git merge origin/main` inside `openscreamer/`. Keep the branch small: `port/src/mister.[ch]` and lines inside `#ifdef MISTER_HYBRID` (search for `MISTER:`).
- The game's data (the DATA, GFX and CONFIG folders of a Screamer installation) goes in `games/OpenScreamer/`, settings and saves in `games/OpenScreamer/saves/`. Never in a repository or a zip.
- Static SDL and the port's "parts": the port puts its own statics back between menu, race and intro. `port/CMakeLists.txt` joins the game's objects into one and renames their `.data` / `.data.rel*` / `.bss` to `osdata` / `osbss`; `port.c` saves only those. A new writable section in the objects (see `readelf -S`) must be added to that list.
- Time is the core's fields: `SDL_GetTicks()` is `mister_ticks()` in the game (`port.h`), and a picture is shown once a field (`SDL_MISTER_VSYNC`, set before `SDL_Init`). `SDL_UpdateTexture` in `main.c` is `mister_show()`: the 32-bit picture to the window's RGB565 surface, no renderer.
- Music: `fmchip.c` sends the register writes to the core's chip (`mister_fm_*`), `sound.c` says where in the audio block (`fmchip_at`). FM volume = 32 x 2.6 x the port's music level.
- Resolution is the OSD's (`O[24]`, read when a part of the program starts; Hires greyed out by menu-mask bit 0 without the H files). Still to do: take the line out of the game's own OPTIONS page, follow a change at once, 640x400.
- Buttons: `J1` = Accelerate, Brake, Gear Up, Gear Down, View, Radar, Back, Start; `mister_pad_mapping()` gives them SDL's controller names for `controls.c`; Menu OK / Back are the "stick buttons" there.
- `OS_FPSLOG=1` (set in the launch script for now): every ten seconds the log has the pictures a second and the milliseconds a picture took to make.
- Test on the PC: `./build.sh host`, `build/host/fakecore shm script audio.raw &`, then `MISTER_HYBRID_SHM=$PWD/shm OPENSCREAMER_HOME=<scratch> build/host/openscreamer -data ~/openscreamer/screamer`.

### State, 2026-10-11

Runs on the MiSTer at 320x200: intro, menus, race, music on the chip. Too slow: 32 to 41 ms a picture in the intro (25 to 30 a second; 16.7 ms is the goal). Profile on the ARM (a `-pg` build run by hand with `/tmp/openscreamer_nolaunch`): `raster_tri` 33 %, `track_under` 25 % (0.2 ms a call, 87 calls a picture in the intro: the opponents' ground), `draw_object` 11 %, integer division (`__divsi3`: the A9 has no divide instruction) 3 %. Not yet looked at: the physics' 50 steps a second against 59.64 fields, the README's TODOs, the GitHub repository (`ItsDanik/openscreamer_MiSTer`, not created yet).
