#! /bin/zsh

# Git Completion in Zsh is suuuuuper slow. Several seconds wait after
# each TAB. We switch off context-awareness, i.e. only adding dirty
# files when auto-completing `git add`. Though at least we get
# performance.
# See: https://superuser.com/a/459057
# And: https://www.zsh.org/mla/workers/2011/msg00490.html

# map alt-, to complete files
zle -C complete-files complete-word _generic
zstyle ':completion:complete-files:*' completer _files
bindkey '^[,' complete-files

# disable git file completion because it's so slow
__git_files () { 
    _wanted files expl 'local files' _files     
}
