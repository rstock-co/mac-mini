# dotfiles.sh - Bare git dotfiles management

# dotfiles - manage dotfiles with bare git repo
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Common shortcuts
# dfs - dotfiles status
alias dfs='dotfiles status'
# dfa - dotfiles add
alias dfa='dotfiles add'
# dfc - dotfiles commit
alias dfc='dotfiles commit'
# dfp - dotfiles push
alias dfp='dotfiles push'
# dfl - dotfiles pull
alias dfl='dotfiles pull'
