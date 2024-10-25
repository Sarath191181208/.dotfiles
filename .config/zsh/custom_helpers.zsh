# Simple sqlplus function to connect and make command text editing work and history
function sqlplus2 {
        socat READLINE,history=$HOME/.sqlplus_history EXEC:"$ORACLE_HOME/bin/sqlplus $(echo $@ | sed 's/\([\:]\)/\\\1/g')",pty,setsid,ctty
        status=$?
}

# fn to use fvm flutter if .fvm directory exists
function fvm_flutter {
    if [ -d ".fvm" ]; then
      fvm flutter $@
    else
      command flutter $@
    fi 
}

# fn to use fvm dart if .fvm directory exists
function fvm_dart {
    if [ -d ".fvm" ]; then
      fvm dart $@
    else
      command dart $@
    fi 
}

# fn to use pipenv insted of pip if Pipenv
function pipenv_alt() {
  # If the first argument is "i", replace it with "install" 
  if [ "$1" = "i" ]; then
      set -- install "${@:2}"
  fi

  if is_pipenv_venv || [ -f "Pipfile" ]; then
      pipenv $@
  else
      command pip $@
  fi
}

# runs the tmux file
function activate_tmux_on_cd {
  local tmux_file=".tmux"
  
  # if no .tmux return
  if [ ! -f "$tmux_file" ]; then
    return
  fi

  if __ask_y_n "Activate $(clr "\`tmux\`" CYAN)?" "y"; then 
    source "./$tmux_file"  # Source (execute) .tmux file
    return 0
  fi

}

function crackme() {
  bash /home/sarath/.config/zsh/scripts/crackme.sh "$1"
}

# venv cheker in cd
function activate_venv_on_cd() {
    # Define the base Projects directory, virtualenv folder name, and Pipfile
    PROJECTS_DIR="$HOME/Projects"
    VENV_DIR="venv"
    PIPFILE="Pipfile"

    # Return early if the directory is not in ~/Projects
    if [[ "$PWD" != "$PROJECTS_DIR"* ]]; then
        return
    fi

    # If Pipfile exists, ask to activate the pipenv environment
    if [[ -f "$PWD/$PIPFILE" ]]; then
      if __ask_y_n "Activate $(clr "\`venv\`" CYAN)?" "y"; then 
        source "$(pipenv --venv)/bin/activate"
        return 0
      else
        return 0
      fi
    fi

    # If venv directory exists, ask to activate the virtual environment
    if [[ -d "$PWD/$VENV_DIR" ]]; then
      if __ask_y_n "Activate $(clr "\`venv\`" CYAN)?" "y"; then 
        source "$PWD/$VENV_DIR/bin/activate"
        return 0
      else
        return 0
      fi
    fi
}

# FVM and Dart completion script
[[ -f /home/sarath/.dart-cli-completion/zsh-config.zsh ]] && . /home/sarath/.dart-cli-completion/zsh-config.zsh || true

is_pipenv_venv() {
    if [ -n "$VIRTUAL_ENV" ]; then
        if echo "$VIRTUAL_ENV" | grep -q 'virtualenvs'; then
            return 0  # True: The path contains 'pipenv'
        else
            return 1  # False: The path does not contain 'pipenv'
        fi
    fi
    return 1  # No virtual environment is activated
}

# Function to ask a yes or no question
function __ask_y_n() {
    local prompt="$1"
    local default="$2"
    
    # Default to "y" if not specified
    if [[ -z "$default" ]]; then
        default="y"
    fi
    
    # Prompt the user
    while true; do
        echo -n "$prompt (y/n) [${default}]? "
        read response

        # Set response to default if empty
        response=${response:-$default}
        case "$response" in
            [yY]*) return 0 ;;  # Yes
            [nN]*) return 1 ;;  # No
            *) echo "Please answer 'y' or 'n'." ;;  # Invalid response
        esac
    done
}
