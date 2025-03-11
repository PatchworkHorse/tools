eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
eval "$(oh-my-posh --init --shell bash --config ~/.poshthemes/lightgreen.omp.json)"

# Useful Aliases
alias sync-google="rclone copy google:/Dropbox/Photos ~/Pictures/"

# Useful functions 
cdd() { 
  mkdir "$1" && cd $_
}

