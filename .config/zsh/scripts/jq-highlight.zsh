# Define groups of jq syntax elements:
typeset -ga jq_operators
jq_operators=(
    add
    flatten
    group_by
    has
    keys
    length
    limit
    map
    max
    max_by
    min
    min_by
    reverse
    select
    sort
    sort_by
    split
    tostring
    unique_by
    to_entries
    strings
)

typeset -ga jq_dot
jq_dot=( "." "..")

typeset -ga jq_bar
jq_bar=( "|" )

typeset -ga jq_booleans
jq_booleans=( "true" "false" )

_zsh_highlight_highlighter_jq_predicate() {
    _zsh_highlight_buffer_modified
}

# Generalized function to highlight keywords from a list
highlight_keywords() {
    local inner=$1
    local token_start=$2
    local token_name=$3
    shift 3
    local keywords=("$@")  # Handle array of keywords

    local keyword
    for keyword in "${keywords[@]}"; do
        if [[ "$inner" == *"$keyword"* ]]; then
            local abs_start=$(( token_start + 1 + ${#inner%%$keyword*} ))
            local abs_end=$(( abs_start + ${#keyword} ))
            _jq_highlight_region "$abs_start" "$abs_end" "$token_name"
        fi
    done
}

# Helper: highlight a region (using a given style key)
_jq_highlight_region() {
    local start=$1
    local end=$2
    local style_key=$3
    _zsh_highlight_add_highlight "$start" "$end" "$style_key"
}

extract_inner_quotes() {
    # get array input
    local -a input
    input=("$@")

    # select contents inside quotes
    local _out
    _out=$(noglob echo "${input[@]:1}" | sed -n 's/.*"\([^"]*\)".*/\1/p')

    # return only the inner content
    printf "%s" "$_out"
}

regex_match() {
    local str=$1
    local pattern=$2
    local match mbegin mend  # Avoid polluting global vars

    if [[ "$str" =~ "$pattern" ]]; then
        return 0  # Match
    else
        return 1  # No match
    fi
}

process_segment_if_jq() {
    local segment=$1
    local -a tokens
    tokens=("${(z)segment}")  # Tokenizing the segment

    # Ensure that the segment starts with "jq"
    [[ "${tokens[1]}" != "jq" ]] && return

    local inner
    inner=$(extract_inner_quotes "${tokens[@]}")

    # use bash to split the inner string into an array
    local split_inner
    IFS=' ' read -r split_inner <<< "$inner"
    inner=("${(z)split_inner}")  # Tokenizing the inner string

    # Check if the inner string is empty
    [[ -z "$inner" ]] && return

    # Check if the inner string contains only whitespace
    [[ "$inner" =~ ^[[:space:]]*$ ]] && return

    local token
    local buffer_prev=0
    for token in "${inner[@]}"; do
        local buffer_tail="${BUFFER:$((buffer_prev))}"
        local relative_index="${buffer_tail%%$token*}"
        local relative_index="${#relative_index}"  # Get the position of the token in the buffer
        if (( relative_index == 0 )); then
            break  # token not found
        fi
        local token_start=$(( buffer_prev + relative_index - 1 ))
        local token_end=$(( token_start + ${#token} ))
        buffer_prev=$token_end

        # Highlight the token
        echo "token: $token start: $token_start end: $token_end" >> /tmp/out.log

        # Highlight different jq keywords
        highlight_keywords "$token" "$token_start" "jq:operator" "${jq_operators[@]}"
        highlight_keywords "$token" "$token_start" "jq:dot" "${jq_dot[@]}"
        highlight_keywords "$token" "$token_start" "jq:bar" "${jq_bar[@]}"
        highlight_keywords "$token" "$token_start" "jq:boolean" "${jq_booleans[@]}"

        token_start=$((token_start+1))
        token_end=$((token_end+1))
        if regex_match "$token" '^-?[0-9]+(\.[0-9]+)?([eE][-+]?[0-9]+)?$'; then
            _jq_highlight_region "$token_start" "$token_end" "jq:number"
        elif regex_match "$token" '^".*"$'; then
            _jq_highlight_region "$token_start" "$token_end" "jq:string"
        elif [[ "$token" == "null" ]]; then
            _jq_highlight_region "$token_start" "$token_end" "jq:null"
        fi
    done
}

# Paint function: highlights content in quoted jq queries.
_zsh_highlight_highlighter_jq_paint() {
    echo "in paint: " > /tmp/out.log
    [[ -z "$BUFFER" ]] && return

    local -a tokens
    tokens=("${(z)BUFFER}")  # Tokenize properly

    local -a segments
    segments=("${(@f)$(split_top_level_pipes "${tokens[@]}")}")

    local segment
    for segment in "${segments[@]}"; do
        process_segment_if_jq "$segment"
    done

    # stop highlight gettig into the next historic command
    _zsh_highlight_reset

    echo "segments: ${segments[@]}" >> /tmp/out.log
}

split_top_level_pipes() {
    local tokens=("$@")
    local segment=""
    local -a result

    local token
    for token in "${tokens[@]}"; do
        if [[ "$token" == "|" ]]; then
            result+=("$segment")
            segment=""
        else
            segment+="${segment:+ }$token"
        fi
    done

    result+=("$segment")
    printf "%s\n" "${result[@]}"
}

# Reset highlighting after command execution
_zsh_highlight_reset() {
    # weird behavior don't know why this works :)
    region_highlight+=( "0 0 bg=1, memo=zsh-syntax-highlighting-jq" )
}

# Hook to reset highlights after command execution
preexec() {
    _zsh_highlight_reset
}

typeset -A ZSH_HIGHLIGHT_STYLES
# Catppuccin Mocha Theme
: ${ZSH_HIGHLIGHT_STYLES[jq:operator]:=fg=#89b4fa,memo=zsh-syntax-highlighting-jq}  # Blue
: ${ZSH_HIGHLIGHT_STYLES[jq:dot]:=fg=#f38ba8,memo=zsh-syntax-highlighting-jq}       # Red
: ${ZSH_HIGHLIGHT_STYLES[jq:bar]:=fg=#a6e3a1,memo=zsh-syntax-highlighting-jq}       # Green
: ${ZSH_HIGHLIGHT_STYLES[jq:string]:=fg=#f9e2af,memo=zsh-syntax-highlighting-jq}    # Yellow
: ${ZSH_HIGHLIGHT_STYLES[jq:number]:=fg=#fab387,memo=zsh-syntax-highlighting-jq}    # Peach
: ${ZSH_HIGHLIGHT_STYLES[jq:boolean]:=fg=#94e2d5,memo=zsh-syntax-highlighting-jq}   # Teal
: ${ZSH_HIGHLIGHT_STYLES[jq:null]:=fg=#cba6f7,memo=zsh-syntax-highlighting-jq}      # Lavender
