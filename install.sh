#!/bin/bash

# Colors for output
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[1;33m'
no_color='\033[0m' # No Color

echo -e "${green}Installing SDDM Hacker Theme...${no_color}"

# Install dependencies
echo -e "${yellow}Installing dependencies...${no_color}"
sudo pacman -S --needed --noconfirm ttf-jetbrains-mono-nerd qt6-declarative qt6-multimedia qt6-wayland

# Clone repository
echo -e "${yellow}Cloning repository...${no_color}"
if [ -d "sddm-hacker-theme" ]; then
    rm -rf sddm-hacker-theme
fi
git clone https://github.com/Qaddoumi/sddm-hacker-theme.git
cd sddm-hacker-theme

sudo rm -rf /usr/share/sddm/themes/hacker-theme || true

# Create theme directory
echo -e "${yellow}Creating theme directory...${no_color}"
sudo mkdir -p /usr/share/sddm/themes/hacker-theme

# Copy all theme files (including theme.conf)
echo -e "${yellow}Copying theme files...${no_color}"
sudo cp Main.qml matrix.js theme.conf /usr/share/sddm/themes/hacker-theme/

# Copy assets directory if it exists
if [ -d "assets" ]; then
    sudo cp -r assets /usr/share/sddm/themes/hacker-theme/
else
    echo -e "${yellow}Creating assets directory...${no_color}"
    sudo mkdir -p /usr/share/sddm/themes/hacker-theme/assets
fi

# Clean up
cd ..
rm -rf sddm-hacker-theme

# Set proper permissions
# echo -e "${yellow}Setting permissions...${no_color}"
# sudo chown -R root:root /usr/share/sddm/themes/hacker-theme
# sudo chmod -R 755 /usr/share/sddm/themes/hacker-theme

# Configure SDDM
echo -e "${yellow}Configuring SDDM...${no_color}"

if [ -f "/etc/sddm.conf" ]; then
    echo -e "${green}Backing up the config file and removing it${no_color}"
    sudo cp /etc/sddm.conf /etc/sddm.conf.backup
    sudo rm -f /etc/sddm.conf || true
    echo -e "${green}Backed up existing SDDM config to /etc/sddm.conf.backup${no_color}"
fi

echo -e "{green}creating a new config file ${no_color}"
sudo tee /etc/sddm.conf > /dev/null << 'EOF'
[Theme]
Current=hacker-theme
[General]
DisplayServer=wayland
Greeter=qt6
GreeterEnvironment=QT_LOGGING_RULES="qt5ct.debug=false"
EOF

echo -e "${green}Installation complete!${no_color}"
echo -e "${yellow}Next steps:${no_color}"
echo ". Restart SDDM: sudo systemctl restart sddm (or reboot)"
echo ". Check logs if there are issues: journalctl -u sddm -f"
