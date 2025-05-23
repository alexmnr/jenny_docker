################### Path ####################
typeset -U path
path+=(/usr/sbin)
path+=(/usr/local/bin)

if [ -d $HOME/bin ]; then
    path+=($HOME/bin)
fi
if [ -d $HOME/.local/bin ]; then
    path+=($HOME/.local/bin)
fi

export ZSH="/usr/local/zsh/oh-my-zsh"

################### Oh my zsh ###############
ZSH_THEME="bira"

plugins=(
	zsh-syntax-highlighting
	zsh-autosuggestions
)

ZSH_DISABLE_COMPFIX=true

source $ZSH/oh-my-zsh.sh
################### Aliases #################
alias src="exec zsh"
alias la="ls -alh"

##################### fzf ###################
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

##################### ros ###################
# source ros distro
source /opt/ros/jazzy/setup.zsh &> /dev/null

source $HOME/jenny_ros2/ros/install/local_setup.zsh

# autocompletion
if command -v register-python-argcomplete3 &> /dev/null; then
  eval "$(register-python-argcomplete3 ros2)"
  eval "$(register-python-argcomplete3 colcon)"
fi
if command -v register-python-argcomplete &> /dev/null; then
  eval "$(register-python-argcomplete ros2)"
  eval "$(register-python-argcomplete colcon)"
fi
