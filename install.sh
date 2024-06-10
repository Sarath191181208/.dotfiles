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
  "python3",
  "git",
  "gh",
  "zsh",
  "neovim",
  "kitty",
  "fzf",
  "ripgrep",
  "mcfly",
  "i3",
  "i3status",
  "nodejs",
  "npm"
)

for package in "${packages[@]}"
do
    echo "Installing $package"
    installPackage $package
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

# Putting config files in place
cp .zshrc ~/.zshrc 
cp .gitconfig ~/.gitconfig 

# i3 config 
mkdirCP i3/config ~/.config/i3/config
mkdirCP i3status/config ~/.config/i3status/config

# kitty config
mkdirCP kitty/kitty.conf ~/.config/kitty/kitty.conf 
mkdirCP kitty/current-theme.conf ~/.config/kitty/current-theme.conf

# neovim config
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 
git clone https://github.com/Sarath191181208/nvim-config ~/.config/nvim/lua/custom --depth 1
