export CDPATH=$HOME/dev
export CLICOLOR=1
export EDITOR=vim
export LANG=en_US.UTF-8
export PATH=$PATH:$HOME/bin:$HOME/google-cloud-sdk/bin

# Add custom completions
zshrc_path=$(readlink $HOME/.zshrc)
zshrc_dir=${zshrc_path%/*}
zsh_comp_dir="${zshrc_dir}/zsh-completion"
fpath=($zsh_comp_dir $fpath)
