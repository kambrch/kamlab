complete -c gwt -s r -l remote -d "Create from origin/<branch> if local branch is missing"
complete -c gwt -n '__fish_is_git_repository' -a '(__fish_git_branches)' -d "Git branch"
