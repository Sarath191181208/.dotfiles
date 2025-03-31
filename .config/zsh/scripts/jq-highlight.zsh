# Define groups of jq syntax elements:
typeset -ga jq_operators
jq_operators=( map select has length keys sort group_by sort_by)

typeset -ga jq_dot
jq_dot=( "." )

typeset -ga jq_bar
jq_bar=( "|" )

typeset -ga jq_booleans=( "true" "false" )

_zsh_highlight_highlighter_jq_predicate() {
  _zsh_highlight_buffer_modified
}

# Generalized function to highlight keywords from a list
highlight_keywords() {
  local inner=$1
  local token_start=$2
  local token_name=$3
  shift 3
  local keywords=("$@")  # Correctly handle array of keywords

  local search_start=0
  local abs_start abs_end keyword remainder

  for keyword in "${keywords[@]}"; do
    search_start=0
    while true; do
      remainder="${inner:$search_start}"  # Extract substring from search_start
      local pos=${remainder%%"$keyword"*}

      if [[ "$remainder" == *"$keyword"* ]]; then
        pos=${#pos}  # Length of prefix before keyword
        abs_start=$(( token_start + 1 + search_start + pos ))
        abs_end=$(( abs_start + ${#keyword} ))
        _jq_highlight_region "$abs_start" "$abs_end" "$token_name"
        search_start=$(( search_start + pos + ${#keyword} ))
      else
        break
      fi
    done
  done
}

# Helper: highlight a region (using a given style key)
_jq_highlight_region() {
  local start=$1
  local end=$2
  local style_key=$3
  _zsh_highlight_add_highlight "$start" "$end" "$style_key"
}

# Paint function: highlights content in quoted jq queries.
_zsh_highlight_highlighter_jq_paint() {

  local -a words
  local token token_start token_end
  words=("${(z)BUFFER}")  # Tokenize the entire command line

  local inner search_start pos remainder keyword abs_start abs_end

  # Check if the command line is in a valid state
  if [[ -z "$BUFFER" ]]; then
    return
  fi

  for token in "${words[@]}"; do
    # Determine token's starting and ending positions in BUFFER.
    token_start=${#${BUFFER%%"$token"*}}
    token_end=$(( token_start + ${#token} ))

    # Skip highlighting for the command "jq" itself.
    if [[ "$token" == "jq" ]]; then
      continue
    fi

    # Return if there are not greater than 2 chars
    if [[ ${#token} -lt 3 ]]; then
      continue
    fi

    # Skip tokens that don't start or end with a quote
    if [[ "${token[1]}" != [\'\"]  || "${token[-1]}" != [\'\"] ]]; then
      continue 
    fi

    # Strip the outer quotes
    inner="${token[2,-2]}"  # Fix: properly strip the first and last character (quotes)

    highlight_keywords "$inner" "$token_start" "jq:operator" "${jq_operators[@]}"

    # Highlight dot(s) with a special style
    highlight_keywords "$inner" "$token_start" "jq:dot" "${jq_dot[@]}"

    # Highlight bar
    highlight_keywords "$inner" "$token_start" "jq:bar" "${jq_bar[@]}"

   highlight_keywords "$inner" "$token_start" "jq:boolean" "${jq_booleans[@]}"

    # Numbers
    if [[ "$inner" =~ ^-?[0-9]+(\.[0-9]+)?([eE][-+]?[0-9]+)?$ ]]; then
      _jq_highlight_region "$token_start" "$token_end" "jq:number"
    fi

    # Strings
    if [[ "$inner" =~ ^\".*\"$ ]]; then
      _jq_highlight_region "$token_start" "$token_end" "jq:string"
    fi

    # `null` keyword
    if [[ "$inner" == "null" ]]; then
      _jq_highlight_region "$token_start" "$token_end" "jq:null"
    fi

  done

  _zsh_highlight_reset
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
# Define default styles.
: ${ZSH_HIGHLIGHT_STYLES[jq:operator]:=fg=#89b4fa,memo=zsh-syntax-highlighting-jq}  
: ${ZSH_HIGHLIGHT_STYLES[jq:dot]:=fg=#ff3b38,memo=zsh-syntax-highlighting-jq}      
: ${ZSH_HIGHLIGHT_STYLES[jq:bar]:=fg=#a6e3a1,memo=zsh-syntax-highlighting-jq}     
: ${ZSH_HIGHLIGHT_STYLES[jq:string]:=fg=#f9e2af,memo=zsh-syntax-highlighting-jq}    
: ${ZSH_HIGHLIGHT_STYLES[jq:number]:=fg=#fab387,memo=zsh-syntax-highlighting-jq} 
: ${ZSH_HIGHLIGHT_STYLES[jq:boolean]:=fg=#94e2d5,memo=zsh-syntax-highlighting-jq}   
: ${ZSH_HIGHLIGHT_STYLES[jq:null]:=fg=#cdd6f4,memo=zsh-syntax-highlighting-jq}   
export zsh_highlight__memo_feature=true
