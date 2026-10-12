OpenScreamer for MiSTer - Screamer as a hybrid core
====================================================

The game is OpenScreamer (https://github.com/ItsDanik/openscreamer), a
reimplementation of Screamer (Graffiti / Virgin Interactive, 1995, MS-DOS)
written from the original program. It runs on the MiSTer's ARM CPU; the
OpenScreamer FPGA core provides native 15kHz video (CRT, VGA and HDMI) at
320x200, 320x240, 640x200 or 640x240, audio, the music's FM chip and input.

Disclaimer: AI is being used to speed up development of this project.

Requirements
  - danik_hybrid_cores, the launcher that comes with this release
    (Scripts/danik_hybrid_cores.sh): copy it to /media/fat/Scripts/ and run
    it ONCE from the MiSTer's Scripts menu. It starts the game whenever
    the core is loaded, keeps running after a reboot, and serves all our
    hybrid cores. Every hybrid core brings the launcher along and the
    newest version is the one that runs, so it never has to be run again
    after an update. Without it the core only shows the MiSTer logo.
  - Game data. It is not included: the DATA and GFX folders of the original
    DOS game Screamer (1995). Tested with the retail CD version. The game
    is still sold; you need your own copy.

Install
  1. Copy _Other/OpenScreamer_*.rbf to /media/fat/_Other/
  2. Copy games/OpenScreamer/ to /media/fat/games/OpenScreamer/
  3. Copy the game's DATA and GFX folders, as they are, to
     /media/fat/games/OpenScreamer/ (so that there is
     /media/fat/games/OpenScreamer/DATA/GEN.DAT, .../GFX/GAME.DAT and so
     on; upper or lower case does not matter). Nothing has to be unpacked.
     From GFX the six MAP1H.DAT .. MAP6H.DAT are not used and can be left
     out. The game's CONFIG folder is optional: if CONFIG/CONTROLS.CFG is
     there, its keyboard keys are used. Nothing else of the game is needed.
     The game checks its data every time it starts; if a file is missing
     or damaged the log says which.
  4. Run danik_hybrid_cores from the Scripts menu, if you have not done so
     before (see Requirements).
  5. Load OpenScreamer from the Other menu.

OSD options
  Aspect ratio, Scale, Scandoubler Fx, Stereo Mix as in other cores.
  FPS Counter   shows the pictures per second in the top left corner.
  HDMI Only     Yes if no CRT is connected: resolutions of 640x400 and
                more are then progressive instead of interlaced, and the
                analog output is switched off while one is shown, so that a
                15kHz screen can never get such a signal. Nothing changes
                at lower resolutions. Not needed with forced_scandoubler=1
                (VGA monitor); not there with direct_video=1.
  CRT Options   for a 15kHz screen: Horizontal Size, Horizontal Pos and
                Vertical Pos fit the picture to it. The pixels stay as they
                are; HDMI is not affected. Not there with
                forced_scandoubler=1.
  Resolution    320x200 (default), the game's own; 320x240: more of the
                road and sky above and below; 640x200 and 640x240: twice as
                sharp across, with the game's high-resolution pictures for
                menus and instruments. Nothing is stretched. Changes at once.
                The 640 modes cannot reach 60 pictures a second (30 to 40):
                use Lock to 30 FPS with them.
  Lock to 30 FPS  Off (default) / On: a steady 30 pictures a second, for
                the 640 modes.
  Rumble        Off (default) / On / Strong: the controller shakes on wall hits,
                crashes, contact with other cars, grass, skids and wheelspin.
  Menu OK, Menu Back
                the gamepad button that confirms / goes back in the game's
                menus, whatever it does in the game. MiSTer (default) uses
                the OK/Back buttons of your MiSTer menu.

Controls
  Keyboard (the mouse is not used):
    Up / Down             accelerate / brake; in menus: choose a line
    Left / Right          steer; in menus: change an option, car, track
    Alt / Ctrl (A / Z)    gear up / down (cars with manual transmission)
    C                     next view; F1 bumper, F2 cockpit, F3 near chase,
                          F4 far chase
    M                     radar zoom (three sizes, off)
    P                     the CD player: choose the song, set the volumes
    Backspace             puts the car back onto the road
    Enter                 confirm
    Esc                   back; in a race: leave (it asks first)
    The six driving keys are those of the game's CONFIG/CONTROLS.CFG when
    that file is there. To change one, add a line to saves/openscreamer.cfg:
    key_accelerate=, key_brake=, key_left=, key_right=, key_gear_up= or
    key_gear_down= with a key's name, such as key_brake=Space.
  Gamepad (default mapping):
    Left stick                          steer (analog); in menus: move
    D-pad                               steer; in menus: move
    R2 / L2 (the triggers)              accelerate / brake, analog
    A (Xbox B / PlayStation Circle)     accelerate
    B (Xbox A / PlayStation Cross)      brake
    X (Xbox Y / PlayStation Triangle)   radar zoom
    Y (Xbox X / PlayStation Square)     next view
    L (LB / L1)                         gear down
    R (RB / R1)                         gear up
    Select                              back; in a race: leave (it asks)
    Start                               confirm
  The triggers are read from the controller directly, not through MiSTer's
  button mapping: they need a controller whose triggers are analog (Xbox,
  PlayStation and the like). Standing on the grid, an automatic car only
  takes first gear with the pedal nearly all the way down, as in the
  original.
  Change the buttons in the OSD under "Define OpenScreamer buttons". "Menu OK" and
  "Menu Back" there are only needed for a button without a game function;
  MiSTer doesn't let you assign a button twice, so to confirm with a button
  that also has a game function, pick it in the OSD's Menu OK/Menu Back
  options instead.

Files
  /media/fat/games/OpenScreamer/saves/            settings, best times,
      championship, saved replays, time-attack ghosts (the port's own, not
      the DOS game's CHOICE.DAT). A new game has three tracks and twelve
      cars: the rest is won in the championship, as in the original.
  /media/fat/logs/OpenScreamer/openscreamer.log   the game's log

Credits
  Screamer (1995) by Graffiti, published by Virgin Interactive.
  OpenScreamer, the reimplementation, by Danik with Claude (Anthropic).
  JTOPL by Jose Tejada (jotego): the FM chip in the FPGA.
  Nuked OPL3 by Nuke.YKT: the same chip in software, for the PC build.
  SDL by Sam Lantinga and contributors.
  MiSTer by Sorgelig and the MiSTer-devel contributors.
  MiSTer Frontier by MiSTer Organize
  (https://github.com/MiSTerOrganize/MiSTer_Frontier): thank you for the
  inspiration. Hybrid cores on the MiSTer, and the way their game is
  launched, come from MiSTer Frontier. Our launcher is a separate
  implementation and does not need MiSTer Frontier installed.

License
  OpenScreamer: GPL-3.0 (LICENSE-openscreamer.txt)
  Nuked OPL3: LGPL-2.1 or later (LICENSE-nuked-opl3.txt)
  SDL: zlib (LICENSE-sdl.txt)
  The launcher scripts: GPL-3.0 (LICENSE-gpl3.txt)
  The FPGA core: GPL-2.0
  Source: https://github.com/ItsDanik/openscreamer_MiSTer
          https://github.com/ItsDanik/Hybrid_MiSTer (launcher, framework)
