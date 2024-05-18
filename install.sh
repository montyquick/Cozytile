#!/bin/bash

# Update system 
sudo pacman -Syu --noconfirm

command_check() {
  command -v "$1" >/dev/null 2>&1
}

# Clone and install Paru
if ! command_check paru; then
  echo "Installing Paru build dependencies"
  sudo pacman -S base-devel --noconfirm
  echo "Installing Paru..."
  cd /opt && sudo git clone https://aur.archlinux.org/paru-bin.git && sudo chown -R "${USER}":"${USER}" ./paru-bin && cd paru-bin && makepkg -si --noconfirm
else
  echo "Paru is already installed in your system"
fi 

# Install packages
paru -S qtile python-psutil feh dunst zsh starship playerctl brightnessctl alacritty fastfetch thunar rofi ranger cava pulseaudio alsa-utils neovim vim unzip wget kitty python-pywal zsh-theme-powerlevel10k-git meson ninja --noconfirm --needed

# Check if SDDM is installed and install if not
if pacman -Qs sddm > /dev/null; then
  echo "SDDM is already installed"
else
  echo "SDDM is not installed. Installing..."
  sudo paru -S sddm qt5-quickcontrols qt5ct qt5-graphicaleffects --noconfirm
fi

# Install picom and dependencies
sudo pacman -S libconfig libev uthash pcre --noconfirm

cd /opt && sudo git clone http://github.com/jonaburg/picom && sudo chown -R "${USER}":"${USER}" ./picom && cd picom && meson setup --buildtype=release . build && sudo ninja -C build install

# check for .config directory, make if missing
if [ ! -d /home/"${USER}"/.config ]; then
  mkdir /home/"${USER}"/.config
fi

cp -r /home/"${USER}"/Cozytile/.config/* /home/"${USER}"/.config

#python-pywal && picom-jonaburg && get fonts
if [ ! -d /home/"${USER}"/.local/share/fonts ]; then
  mkdir -p /home/"${USER}"/.local/share/fonts
fi

cd /tmp || exit

fonts=(
  "FiraCode"
  "Meslo"
  "JetBrainsMono"
)

for font in "${fonts[@]}"
do
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/"$font".zip
	unzip "$font".zip -d "$HOME"/.local/share/fonts/"$font"/
    rm "$font".zip
done
fc-cache
# Check and set Zsh as the default shell
#[[ "$(awk -F: -v user="$USER" '$1 == user {print $NF}' /etc/passwd) " =~ "zsh " ]] || chsh -s $(which zsh)

# Install Oh My Zsh
#if [ ! -d ~/.oh-my-zsh/ ]; then
#  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended 
#else
#  omz update
#fi

# Install Zsh plugins
#[[ "${plugins[*]} " =~ "zsh-autosuggestions " ]] || git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
#[[ "${plugins[*]} " =~ "zsh-syntax-highlighting " ]] || git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Make Backup 

#echo "Backing up the current configs. All the backup files will be available at ~/.cozy.bak"
#mkdir -p ~/.cozy.bak

#for folder in .* *; do
#  if [[ -d "$folder" && ! "$folder" =~ ^(\.|\.\.)$ && "$folder" != ".git" ]]; then
#    if [ -d "$HOME/$folder" ]; then
#      echo "Backing up ~/$folder"
#      cp -r "$HOME/$folder" ~/.cozy.bak
#      echo "Backed up ~/$folder successfully."
#      echo "Removing old config for $folder"
#      rm -rf "$HOME/$folder"
#    fi
#    echo "Copying new config for $folder"
#    cp -r "$folder" "$HOME"
#  fi
#done

# Disable currently enabled display manager
#if systemctl list-unit-files | grep enabled | grep -E 'gdm|lightdm|lxdm|lxdm-gtk3|sddm|slim|xdm'; then
#  echo "Disabling currently enabled display manager"
#  sudo systemctl disable --now $(systemctl list-unit-files | grep enabled | grep -E 'gdm|lightdm|lxdm|lxdm-gtk3|sddm|slim|xdm' | awk -F ' ' '{print $1}')
#fi

# Enable and start SDDM
#echo "Enabling and starting SDDM"
sudo systemctl enable --now sddm

