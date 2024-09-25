# Define color codes in an 
# associated dict
declare -A COLORS
COLORS[BOLD]='\e[1m'
COLORS[RED]='\e[31m'
COLORS[GREEN]='\e[32m'
COLORS[YELLOW]='\e[33m'
COLORS[BLUE]='\e[34m'
COLORS[MAGENTA]='\e[35m'
COLORS[CYAN]='\e[36m'
COLORS[RESET]='\e[0m'

# CLR fn
# Example usage
#   >> echo "This is some $(clr "text" BOLD RED)"
#   >> echo "This is $(clr "bold green" BOLD GREEN)"
function clr() {
    local text="$1"
    shift
    local styles=("$@")
    local style_codes=""

    for style in "${styles[@]}"; do
        style_codes+="${COLORS[$style]}"
    done

    # Return the formatted text
    echo -e "${style_codes}${text}${COLORS[RESET]}"
}
