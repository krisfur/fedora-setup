# kitty terminal
sudo dnf install kitty -y #and then get the catpuccin theme from https://github.com/catppuccin/kitty

# git
sudo dnf install git -y

# pip
sudo dnf install python3-pip -y

# vs-code
# works better from their website .rpm than from command line somehow

# chrome
# also get .rpm from their website

# rust
sudo dnf install curl gcc make -y

# C++
sudo dnf install gcc-c++ -y

# node-js - usally already installed tho
sudo dnf install nodejs -y

# neovim
sudo dnf install neovim -y #might need to edit kitty config to make it default

# grub theme
git clone https://github.com/catppuccin/grub.git
cd grub
sudo mkdir -p /usr/share/grub/themes
sudo cp -r src/catppuccin-mocha-grub-theme /usr/share/grub/themes/
sudo nvim /etc/default/grub
# add line GRUB_THEME="/usr/share/grub/themes/catppuccin-mocha-grub-theme/theme.txt"
# comment line # GRUB_TERMINAL_OUTPUT="console"
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
