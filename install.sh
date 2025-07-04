
# Colors for output
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[1;33m'
no_color='\033[0m' # No Color

echo -e "${green}Installing SDDM Hacker Theme...${no_color}"
echo -e "${yellow}Installing dependencies...${no_color}"

sudo pacman -S --needed --noconfirm ttf-jetbrains-mono-nerd qt6-declarative qt6-multimedia
sudo pacman -S --needed --noconfirm qt6-svg qt6-virtualkeyboard qt6-multimedia-ffmpeg
sudo pacman -S --needed --noconfirm qt6-wayland

# Clone repository
echo -e "${yellow}Cloning repository...${no_color}"
if [ -d "sddm-hacker-theme" ]; then
    rm -rf sddm-hacker-theme
fi
git clone https://github.com/Qaddoumi/sddm-hacker-theme.git
cd sddm-hacker-theme

sudo rm -rf /usr/share/sddm/themes/sddm-hacker-theme || true

echo -e "${yellow}Creating theme directory...${no_color}"
sudo mkdir -p /usr/share/sddm/themes/sddm-hacker-theme

echo -e "${yellow}Copying theme files...${no_color}"
sudo cp Main.qml metadata.desktop /usr/share/sddm/themes/sddm-hacker-theme/

echo -e "${yellow}Setting permissions...${no_color}"
sudo chmod 644 /usr/share/sddm/themes/sddm-hacker-theme/Main.qml
sudo chmod 644 /usr/share/sddm/themes/sddm-hacker-theme/metadata.desktop

echo -e "${yellow}Configuring SDDM...${no_color}"
# Create or update SDDM config
if [ ! -f "/etc/sddm.conf" ]; then
    # Create new config file
    sudo tee /etc/sddm.conf > /dev/null << 'EOF'
[Theme]
Current=sddm-hacker-theme

[General]
DisplayServer=wayland
EOF
else
    # Update existing config
    # Remove old theme setting if it exists
    sudo sed -i '/^Current=/d' /etc/sddm.conf
    
    # Add [Theme] section if it doesn't exist
    if ! grep -q "^\[Theme\]" /etc/sddm.conf; then
        echo -e "\n[Theme]" | sudo tee -a /etc/sddm.conf > /dev/null
    fi
    
    # Add theme setting after [Theme] section
    sudo sed -i '/^\[Theme\]/a Current=sddm-hacker-theme' /etc/sddm.conf
fi

sudo mkdir -p /etc/sddm.conf.d
sudo touch /etc/sddm.conf.d/virtualkbd.conf || true
echo "[General]
InputMethod=qtvirtualkeyboard" | sudo tee /etc/sddm.conf.d/virtualkbd.conf || true

# Clean up
cd ..
rm -rf sddm-hacker-theme || true

echo -e "${green}Installation complete!${no_color}"
echo -e "${yellow}Next steps:${no_color}"
echo ". Restart SDDM: sudo systemctl restart sddm (or reboot)"
echo ". Check logs if there are issues: journalctl -u sddm -f"