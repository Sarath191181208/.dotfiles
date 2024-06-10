# write an install script 
# to install the necessary packages
#
#
$ZSH_CUSTOM=/usr/share/zsh/

installPackage() {
    sudo pacman -S $1
}

mkdirCP(){
    mkdir -p $(dirname $2) && cp $1 $2
}

packages=(
  "git",
  "gh",
  "zsh",
  "neovim",
  "fzf",
  "ripgrep",
  "mcfly",
  "unzip",
  "jq", # JSON filter tool
  "stow", # Symlink farm manager
  "ttf-jetbrains-mono-nerd" # font

  "python3",
  "nodejs",
  "npm",
  "gnome-terminal", # imp for docker for some reason
  "docker",
  "docker-compose",
  "lazydocker",

  ##########
  ### DM ###
  ##########
  "sway",
  "swaybg",
  "wlroots",
  "foot",
  "wofi",
  "wlroots", 
  "wl-clipboard",
  "mako", #  notification daemon for Wayland
)

for package in "${packages[@]}"
do
    echo "Installing $package"
    installPackage $package
done

yay_packages = (
  ###########
  ### YAY ###
  ### PKG ###
  ###########
  # " xdg-desktop-portal-wlr " # maybe useful for Screenshot
  "sway-screenshot", # Screenshot tool for sway
  "catppuccin-gtk-theme-mocha",
  "landrop", # local file sharing tool
  "qt5-wayland", # To ensure landrop working with wayland 
)

for package in "${packages[@]}"
do
    echo "Installing $package"
    sudo yay -S $package
done

# Installing zsh plugins 
plugins=(
    "zsh-autosuggestions",
    "zsh-syntax-highlighting",
    "zsh-history-substring-search",
)

for plugin in "${plugins[@]}"
do
    echo "Installing $plugin"
    git clone https://github.com/zsh-users/$plugin.git $ZSH_CUSTOM/plugins/$plugin
done

stow --adopt .

# # Putting config files in place
# cp .zshrc ~/.zshrc 
# cp .gitconfig ~/.gitconfig 
#
# # i3 config 
# mkdirCP i3/config ~/.config/i3/config
# mkdirCP i3status/config ~/.config/i3status/config
#
# # kitty config
# mkdirCP kitty/kitty.conf ~/.config/kitty/kitty.conf 
# mkdirCP kitty/current-theme.conf ~/.config/kitty/current-theme.conf
#
# # neovim config
# git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 
# git clone https://github.com/Sarath191181208/nvim-config ~/.config/nvim/lua/custom --depth 1
