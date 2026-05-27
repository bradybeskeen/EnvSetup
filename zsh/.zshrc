HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

export EDITOR=nvim
alias vim='$EDITOR'

export ZSH="$HOME/.oh-my-zsh"
export PATH=$PATH:$HOME/.local/bin

# Oh My Zsh Plugins
plugins=(
    git
    sudo
    zsh-autosuggestions
    zsh-syntax-highlighting
    copyfile
    copybuffer
    dirhistory
)
# Set-up oh-my-zsh
source $ZSH/oh-my-zsh.sh

eval "$(oh-my-posh init zsh --config ${${(%):-%x}:A:h}/powerlevel10k_brady.omp.json)"

# Create ~/.zshrc.local for all configs specific to current machine.
if [[ -f ~/.zshrc.local ]]; then source ~/.zshrc.local fi
