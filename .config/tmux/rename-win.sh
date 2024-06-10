# Define custom icons for different window names
icon_nvim=""
icon_docker=" "
icon_shell=""
icon_lazy_docker=" "
icon_config=""

# icons          

window_name=$(tmux display-message -p '#W')
icon=""
case "$window_name" in
    "nvim" | "vim") icon="$icon_nvim" ;;
    "docker") icon="$icon_docker" ;;
    "lazydocker") icon="$icon_lazy_docker";;
    "cmd") icon="$icon_shell" ;;
    "config") icon="$icon_config" ;;
    *) icon="$window_name" ;;
esac
tmux rename-window "$icon";
