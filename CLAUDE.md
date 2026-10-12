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
- Resolution is the OSD's: `O[24]` = 320x200 (default) / 320x240, followed at once wherever the program is (`tall_follow`, called with every event poll: the picture's memory always has the 40 extra rows, the window is resized, which sets the core's mode; a paused screen drawn from a kept copy -- the CD player, the question -- looks wrong until it is left). **There is no high resolution on the MiSTer** (Danik, 2026-10-12: the machine cannot fill 640x400): `res_init` forces low, the game's OPTIONS page has no resolution line. 320x240 (`g_tall` = 40 extra rows, `g_oy`, `LAY_TOP/MID/BOT`, `pic_put` in `main.c`; `OS_TALL=1` tries it anywhere, the PC build too): the 3D view has all 240 rows (eye line still 65% down, same lens, so more is seen above and below), and the game's 200-row artwork is never stretched -- whole-screen pictures, menus, the CD player, the question and the end-of-race words sit in the middle (20 black rows above and below a picture), the race's labels, clocks, countdown and start lights at the top, instruments, dashboard, radar and the replay's R at the bottom. Top and bottom things are 8 rows in from the edge (overscan; Danik). It costs about 1 ms a picture.
- Buttons: `J1` = Accelerate, Brake, Gear Up, Gear Down, View, Radar, Back, Start; `mister_pad_mapping()` gives them SDL's controller names for `controls.c`; Menu OK / Back are the "stick buttons" there.
- `OS_FPSLOG=1` (set in the launch script for now): every ten seconds the log has the pictures a second and the milliseconds a picture took to make.
- Test on the PC: `./build.sh host`, `build/host/fakecore shm script audio.raw &`, then `MISTER_HYBRID_SHM=$PWD/shm OPENSCREAMER_HOME=<scratch> build/host/openscreamer -data ~/openscreamer/screamer`.

### State, 2026-10-12

Runs on the MiSTer at 320x200: intro, menus, race, backdrop, music on the chip. Speed with the robot at HI detail (ms a picture; a field is 16.7 and a picture is in time when it takes under about 15.2): track 1 15.5 in the first ten seconds, then 12.4 to 14.0; track 4 16.7, then 12 to 14.4; track 5 17.4, then 14 to 16.4. So: 60 a second everywhere but the first seconds of a race (the grid, ten cars) and one stretch of track 5, where it is 52 to 58. It began at 26 to 33 ms.

What it took, all on the game's branch `mister` (`git log`), checked against the PC's pictures with `build/test/cmp.py` and against one thread:
- the ground search by cell; the rasteriser with nothing divided or tested per row, 8-pixel texture spans, a lean loop for plain pixels, no maths-library calls (`floorf`, `fminf`: the ARM has no instruction for them);
- pieces, cars and props: a face turned away dropped first, a corner placed and projected once, faces off the picture or covering no pixel dropped before they are listed;
- the scene's triangles LISTED and filled by two threads in four lanes (every fourth row each; `lane_work`): the helper on CPU1 starts while the main thread still works the scene out, and paints the backdrop and clears the depths first;
- the backdrop in whole-number steps (it was 15 ms a picture); overlay pictures from runs; NEON to the screen; the audio device opened at 44100 (SDL's resampling took an eighth of CPU1);
- how far is drawn follows the time there is (`render_frame`: the far plane between the DETAIL setting and the game's own MID; `OS_FIXEDFAR=1` switches that off);
- `-O3 -marm -ffast-math` for the ARM build (the robot's telemetry is the same as the PC's to the last digit shown).
Tried and no use (do not try again without a new reason): the perspective division per pixel is not the cost; texture cache misses, the per-pixel buffers and prefetching them; writing colours at the end of the scene; sharing a triangle's set-up between lanes; eight lanes (a triangle's early tests times eight); the environment lookups.
What a picture's time is made of now (grid, track 1): the game 1.5 ms, the scene worked out 6.6 (the ten cars are a third of it), filling 6 after that with both threads busy, HUD 1.4, to the screen 0.7. CPU1 also carries the audio thread (6 %) and the copy of each picture to the core (10 %). The processor does about half an instruction a cycle on this code: everything costs twice what it looks.
Ideas left: hand the finished picture to the helper for the conversion and the copy (about 1 ms of the main thread); an 8-bit picture all the way (the core has a palette: half the copying, no conversion, the original's own way -- a rewrite of everything that draws).

- Measuring: `OS_FPSLOG=1` lines in `/media/fat/logs/OpenScreamer/openscreamer.log`. A fixed test: `/tmp/openscreamer_env` on the MiSTer with `export OS_DRIVE_DEMO=100000 OS_NOREPLAY=1` and `OS_DEV_ARGS="build/dec/MAP1 1"` (the launch script reads it), `OS_BENCH=1` for a still picture, `OS_ONETHREAD=1`, `OS_LANES=n`. A profile: build with `-pg`, run through the launcher, `gmon.out` appears in the game's folder when the game ends in an orderly way.
- Traps: a second copy of the game started by hand next to the launcher's halves every number; killing the game makes the launcher load the MiSTer menu.
- The finished race picture is converted and copied to the core by the helper (`mister_show_later` / `mister_show_job`): done, about 1 ms. With it, robot, HI detail, ms a picture -- 200 rows: track 1 15.1 in the first ten seconds then 12.2 to 13.8, track 4 16.3 then 11.6 to 14.0, track 5 17.0 then 13.4 to 15.8. 240 rows: track 1 16.2 then 13.0 to 14.7, track 4 17.6 then 13.7 to 15.0, track 5 18.4 then 15.2 to 16.8 (50 to 53 pictures a second on the grid, 58 to 60 after).
- **The far plane that followed the time is OFF** (Danik, 2026-10-12: things at the far plane flickered in and out when the speed was marginal); `OS_ADAPTFAR=1` tries it. It had bought little: with it off, robot, HI detail -- 200 rows: track 1 15.4 ms on the grid then 13.4, track 5 17.4 then 14.4; 240 rows: track 1 16.3 then 14.1 to 14.3, track 4 17.6 then 13.3 to 14.9, track 5 18.6 then 15.3 to 16.9. `OS_TALL=0|1` in the test's env file fixes the height (the OSD is not followed then).
- Not done: the physics' 50 steps a second against 59.64 fields; the README's TODOs; the GitHub repository (`ItsDanik/openscreamer_MiSTer`, not created yet).
