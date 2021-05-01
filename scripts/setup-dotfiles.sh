#!/bin/sh

# Simple script to setup all dotfiles into system.
# 
# Usage: [VERBOSE=(true|false)] setup-dotfiles.sh <repo> [target_home]

echov () {
	if [ "${VERBOSE}" = true ]; then
		echo $@
	fi
}

if [ $# -eq 1 ]; then
	SOURCE=$1
	TARGET=$HOME
elif [ $# -eq 2 ]; then
	SOURCE=$1
	TARGET=$2
else
	echo "Invalid arguments."
	echo "Usage: $0 <repo> [target_home]"
	exit 1
fi

echo "Source directory: $SOURCE"
echo "Target directory: $TARGET"

# ~/.config dirs:
CONFIGS="alacritty autostart fontconfig gtk-3.0 htop kanshi mako minidlna neofetch nwg-launchers ranger sway swaylock waybar"

# Remove previous config files
echov "Removing $TARGET/.zshrc"
rm -rf $TARGET/.zshrc
echov "Removing $TARGET/.local/share/applications/"
rm -rf $TARGET/.local/share/applications
echov "Removing $TARGET/.config/libinput-gestures.conf"
rm -rf $TARGET/.config/libinput-gestures.conf

for D in $CONFIGS
do
	echov "Removing $TARGET/.config/$D/"
	rm -rf $TARGET/.config/$D
done

# Create hard links
echov "Creating symlink $TARGET/.zshrc"
ln -sf $SOURCE/.zshrc $TARGET/.zshrc
echov "Creating symlink $TARGET/.local/share/applications/"
mkdir -p $TARGET/.local/share
ln -sf $SOURCE/applications $TARGET/.local/share/applications
mkdir -p $TARGET/.config
echov "Creating symlink $TARGET/.config/libinput-gestures.conf"
ln -sf $SOURCE/libinput-gestures.conf $TARGET/.config/libinput-gestures.conf

for D in $CONFIGS
do
	echov "Creating symlink $TARGET/.config/$D/"
	ln -sf $SOURCE/$D $TARGET/.config/$D
done

echo "Done. Have a nice day ^-^"
