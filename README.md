```
 _____               _     _____ _____ 
|  _  |___ ___ ___ _| |___|_   _|  |  |
|     |  _|  _| .'| . | -_| | | |  |  |
|__|__|_| |___|__,|___|___| |_|  \___/ 
```
# MENU FOR NEO GEO 161in1 MULTICART 
- based on the work of [Vortex](https://github.com/xvortex/VTXCart)
- used Furrtek's "Hello World" [example code](https://wiki.neogeodev.org/index.php?title=Hello_world_tutorial)

This aims to be an alternative menu for the chinese 161in1 multicart that was fully reverse engineered by vortex in 2023.

## Pending:

- [ ] Game-launch on button-press
- [ ] Documentation & instructions
- [ ] Automated gamelist processing
- [ ] Test on real hardware

## Building

On Windows use the `build.bat` file to start the toolchain.
When everything works as expected you'll find the `menu-p1.bin` romfile in the `MAME\roms\menu` folder.

## Gamelist

The list-entries in the rom come from `gamelist.asm`. 
It has several sections to store data that has relations to other data.
Also there are 2 sets of data, the latter is suffixed with `_j`, that is because the menu shows different lists depending on the region that is set either in your system or unibios.

To make it work with vortex' compiler there will some kind of automation in the future.
As of today I generate it dynamically from this [google sheet](https://docs.google.com/spreadsheets/d/1SvTqueoCBW6DWAlXX2c7Bu-1nL3tjjF4dnOUXxzvHcQ/edit?usp=sharing).