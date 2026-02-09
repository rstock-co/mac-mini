# dotfiles.sh - Bare git dotfiles management

# dotfiles - manage dotfiles with bare git repo
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Common dotfiles shortcuts
alias dfs='dotfiles status'
alias dfa='dotfiles add'
alias dfc='dotfiles commit'
alias dfp='dotfiles push'
alias dfl='dotfiles pull'
alias dfd='dotfiles diff'
alias dflog='dotfiles log --oneline --graph --decorate'
