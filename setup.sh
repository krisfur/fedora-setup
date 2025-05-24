# first update dnf
dnf check-update

# kitty terminal
sudo dnf install kitty -y #and then get the catpuccin theme from https://github.com/catppuccin/kitty
# set as default terminal in settings

# git
sudo dnf install git -y

# pip
sudo dnf install python3-pip -y

# vs-code
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
sudo dnf install code 

# chrome
# also get .rpm from their website

# discord
sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install discord

# rust
sudo dnf install curl gcc make -y
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# C++
sudo dnf install gcc-c++ -y

# node-js - usally already installed tho
sudo dnf install nodejs -y

# neovim
sudo dnf install neovim -y #might need to edit kitty config, or export EDITOR=/usr/bin/nvim in /etc/profile to make it default

# grub theme
git clone https://github.com/catppuccin/grub.git
cd grub
sudo mkdir -p /usr/share/grub/themes
sudo cp -r src/catppuccin-mocha-grub-theme /usr/share/grub/themes/
sudo nvim /etc/default/grub
# add line GRUB_THEME="/usr/share/grub/themes/catppuccin-mocha-grub-theme/theme.txt"
# comment line # GRUB_TERMINAL_OUTPUT="console"
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
