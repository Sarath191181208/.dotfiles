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
      flutter $@
    fi 
}

# fn to use fvm dart if .fvm directory exists
function fvm_dart {
    if [ -d ".fvm" ]; then
      fvm dart $@
    else
      dart $@
    fi 
}

# alias to use flutter and dart and respect fvm
alias flutter=fvm_flutter
alias dart=fvm_dart

# FVM and Dart completion script
[[ -f /home/sarath/.dart-cli-completion/zsh-config.zsh ]] && . /home/sarath/.dart-cli-completion/zsh-config.zsh || true
