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
    if [ "$1" = "i" ]; then
        set -- install "${@:2}"
    fi

    if is_pipenv_venv || [ -f "Pipfile" ]; then
        pipenv $@
    else
        command pip $@
    fi
}

# cd and runs tmux after cd 
function cdt {
  cd "$@"  # Change directory with all arguments passed
  local tmux_file=".tmux"
  
  # Check if the .tmux file exists in the current directory
  if [ -f "$tmux_file" ]; then
    source "./$tmux_file"  # Source (execute) .tmux file
  fi
}

# alias to use flutter and dart and respect fvm
alias flutter=fvm_flutter
alias dart=fvm_dart
alias pip=pipenv_alt

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
