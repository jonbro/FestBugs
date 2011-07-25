#############################################################################################
# NOTES:
#
# This Makefile assumes that you have the following installed, setup:
#
#  TexturePacker (http://www.texturepacker.com/) in your path
#  $JSSHELL environment variable in .profile or .bashrc pointing to a SpiderMonkey binary
#  If on Windows, $FIND environment variable in .profile or .bashrc for unixy find cmd
#############################################################################################

JSSHELL ?= $(error Specify a valid path to a js shell binary in ~/.profile: export JSSHELL=C:\path\js.exe or /path/js)

build-sheet:
	@@echo "\nBuilding sprite sheet:"
	@@TexturePacker --format json --disable-rotation --no-trim --data js/sheet.json --sheet img/sheet.png ungrouped_sprites/*.png
