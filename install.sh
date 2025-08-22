#!/bin/bash

# Colors for output
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[1;33m'
no_color='\033[0m' # No Color

cd ~ || echo -e "${red}Failed to change directory to home${no_color}"

echo -e "${green}Installing SDDM Hacker Theme...${no_color}"

echo -e "${green}Installing dependencies...${no_color}"
sudo pacman -S --needed --noconfirm ttf-jetbrains-mono-nerd qt6-declarative qt6-multimedia qt6-wayland qt5-quickcontrols2

echo -e "${green}Cloning repository...${no_color}"
if [ -d "sddm-hacker-theme" ]; then
    sudo rm -rf sddm-hacker-theme
fi
git clone --depth 1 https://github.com/Qaddoumi/sddm-hacker-theme.git ~/sddm-hacker-theme
cd sddm-hacker-theme

sudo rm -rf /usr/share/sddm/themes/hacker-theme || true

echo -e "${green}Creating theme directory...${no_color}"
sudo mkdir -p /usr/share/sddm/themes/hacker-theme

echo -e "${green}Copying theme files...${no_color}"
sudo cp Main.qml matrix.js theme.conf /usr/share/sddm/themes/hacker-theme/

# Copy assets directory if it exists
if [ -d "assets" ]; then
    sudo cp -r assets /usr/share/sddm/themes/hacker-theme/
else
    echo -e "${green}Creating assets directory...${no_color}"
    sudo mkdir -p /usr/share/sddm/themes/hacker-theme/assets
fi

echo -e "${green}Cleaning up${no_color}"
cd ..
#sudo rm -rf sddm-hacker-theme || true

echo -e "${green}Configuring SDDM...${no_color}"

if [ -f "/etc/sddm.conf" ]; then
    echo -e "${green}Backing up the config file and removing it${no_color}"
    sudo cp /etc/sddm.conf /etc/sddm.conf.backup
    sudo rm -f /etc/sddm.conf || true
    echo -e "${green}Backed up existing SDDM config to /etc/sddm.conf.backup${no_color}"
fi

echo -e "${green}creating a new config file ${no_color}"
sudo tee /etc/sddm.conf > /dev/null << 'EOF'
[Theme]
Current=hacker-theme
[General]
Greeter=qt6
[Wayland]
CompositorCommand=sway
EOF

echo -e "${green}Installation complete!${no_color}"
echo -e "${green}Next steps:${no_color}"
echo ". Restart SDDM: sudo systemctl restart sddm (or reboot)"
echo ". Check logs if there are issues: journalctl -u sddm -f"
echo ". Run the following command to test the theme without logging out:"
echo ". sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/hacker-theme"
echo ""
