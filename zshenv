export CDPATH=$HOME/dev
export CLICOLOR=1
export EDITOR=vim
export HOMEBREW_NO_ANALYTICS=1
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export PATH=$PATH:$HOME/bin:$HOME/google-cloud-sdk/bin:$HOME/.cargo/bin
export PYTHONDONTWRITEBYTECODE=1
export ESP_ROOT=$HOME/dev/esp-open-sdk

# Add custom completions
zshrc_path=$(readlink $HOME/.zshrc)
zshrc_dir=${zshrc_path%/*}
zsh_comp_dir="${zshrc_dir}/zsh-completion"
fpath=($zsh_comp_dir $fpath)
