# Set $PATH if ~/.local/bin exist
if [ -d "$HOME/.local/bin" ]; then
    export PATH=$HOME/.local/bin:$PATH
fi


export ORACLE_HOME=/opt/oracle/product/18c/dbhomeXE
export ORACLE_SID=XE
export EDITOR=nvim
export PATH=$PATH:$ORACLE_HOME/bin
export PATH=$PATH:$(go env GOPATH)/bin

export MCFLY_FUZZY=true
export MCFLY_RESULTS=20
export MCFLY_INTERFACE_VIEW=BOTTOM
export MCFLY_RESULTS_SORT=LAST_RUN


source ~/.config/zsh/aliases.zsh
source ~/.config/zsh/bindings.zsh
source ~/.config/zsh/completion.zsh
source ~/.config/zsh/custom_helpers.zsh
source ~/.config/zsh/options.zsh
source ~/.config/zsh/plugins.zsh

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
eval "$(mcfly init zsh)"
