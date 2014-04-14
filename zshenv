export CDPATH=$HOME/dev
export EDITOR=vim
export LANG=en_US.UTF-8
export LC_TIME=en_DK.UTF-8
export PATH=$PATH:$HOME/bin:$HOME/google-cloud-sdk/bin

# Add custom completions
zshrc_path=$(/bin/readlink -f $HOME/.zshrc)
zshrc_dir=${zshrc_path%/*}
zsh_comp_dir="${zshrc_dir}/zsh-completion"
fpath=($zsh_comp_dir $fpath)
