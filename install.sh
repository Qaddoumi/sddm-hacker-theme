#!/usr/bin/env bash

# Colors for output
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[1;33m'
no_color='\033[0m' # No Color

for tool in sudo doas pkexec; do
	if command -v "${tool}" >/dev/null 2>&1; then
		ESCALATION_TOOL="${tool}"
		echo -e "${cyan}Using ${tool} for privilege escalation${no_color}"
		break
	fi
done

if [ -z "${ESCALATION_TOOL}" ]; then
	echo -e "${red}Error: This script requires root privileges. Please run as root or install sudo, doas, or pkexec.${no_color}"
	exit 1
fi

cd ~ || echo -e "${red}Failed to change directory to home${no_color}"

echo -e "${green}Installing SDDM Hacker Theme...${no_color}"

echo -e "${green}Installing dependencies...${no_color}"
"$ESCALATION_TOOL" pacman -S --needed --noconfirm git ttf-jetbrains-mono-nerd ffmpeg qt6-declarative qt6-multimedia qt6-wayland || \
"$ESCALATION_TOOL" xbps-install -y git ffmpeg qt6-declarative qt6-multimedia qt6-wayland

echo -e "${green}Cloning repository...${no_color}"
if [ -d "sddm-hacker-theme" ]; then
	"$ESCALATION_TOOL" rm -rf sddm-hacker-theme
fi
git clone --depth 1 https://github.com/Qaddoumi/sddm-hacker-theme.git ~/sddm-hacker-theme
cd sddm-hacker-theme

"$ESCALATION_TOOL" rm -rf /usr/share/sddm/themes/hacker-theme || true

echo -e "${green}Creating theme directory...${no_color}"
"$ESCALATION_TOOL" mkdir -p /usr/share/sddm/themes/hacker-theme

echo -e "${green}Copying theme files...${no_color}"
"$ESCALATION_TOOL" cp Main.qml matrix.js theme.conf /usr/share/sddm/themes/hacker-theme/

# Copy assets directory if it exists
if [ -d "assets" ]; then
	"$ESCALATION_TOOL" cp -r assets /usr/share/sddm/themes/hacker-theme/
else
	echo -e "${green}Creating assets directory...${no_color}"
	"$ESCALATION_TOOL" mkdir -p /usr/share/sddm/themes/hacker-theme/assets
fi

"$ESCALATION_TOOL" chmod -R 755 /usr/share/sddm/themes/hacker-theme/assets

echo -e "${green}Cleaning up${no_color}"
cd ..
"$ESCALATION_TOOL" rm -rf sddm-hacker-theme || true

echo -e "${green}Configuring SDDM...${no_color}"

if [ -f "/etc/sddm.conf" ]; then
	echo -e "${green}Backing up the config file and removing it${no_color}"
	"$ESCALATION_TOOL" cp -af /etc/sddm.conf /etc/sddm.conf.backup
	"$ESCALATION_TOOL" rm -f /etc/sddm.conf || true
	echo -e "${green}Backed up existing SDDM config to /etc/sddm.conf.backup${no_color}"
fi

echo -e "${green}creating a new config file ${no_color}"
"$ESCALATION_TOOL" tee /etc/sddm.conf > /dev/null << 'EOF'
[Theme]
Current=hacker-theme
EOF

### Making sure sddm starts with qt6 and not qt5
# Count how many sddm-greeter files exist
# sddm-greeter-qt6 is the qt6 version
# sddm-greeter is the qt5 version
greeter_count=$(ls -1 /usr/bin/sddm-greeter* 2>/dev/null | wc -l)
if [ "$greeter_count" -eq 2 ]; then
	"$ESCALATION_TOOL" mv /usr/bin/sddm-greeter /usr/bin/sddm-greeter.qt5.backup
	"$ESCALATION_TOOL" ln -s /usr/bin/sddm-greeter-qt6 /usr/bin/sddm-greeter
fi

echo -e "${green}Installation complete!${no_color}"
echo -e "${green}Next steps:${no_color}"
echo ". Restart SDDM to see the changes (or reboot)"
echo ". Check logs if there are issues: journalctl -u sddm -f"
echo ". Run the following command to test the theme without logging out:"
echo ". sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/hacker-theme"
echo ""
