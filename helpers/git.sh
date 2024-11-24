#!/bin/bash
_dir=$( dirname $(readlink -e -- "${BASH_SOURCE}"))
source $_dir/io.sh || exit 255
source $_dir/basic.sh || exit 255
source $_dir/pkg.sh || exit 255

########################################################
# Shorthands for git
########################################################

git.clone_quick() {
    require git
    git clone --depth=1 --single-branch $*
}

git.is_repo() {
    require git
    [ "$1" ] || die "Path is not specified" 101
    require_dir "$1/"
    check_dir "$1/.git"
}

git.require_repo() {
    require git
    git.is_repo "$1" || die "'$1' is not git repository!" 10
}

git.cfg() {
    require git
    [ "$1" ] || die "Key is not specified" 101
    if [[ "$2" ]]; then
        git config --global --replace-all "$1" "$2"
    else
        echo $(git config --global --get-all "$1")
    fi
}

git.set_user() {
    require git
    [ "$1" ] || die "git.set_user: Repo is not specified" 100
    git.cfg "$1" "user.name" "$2"
    git.cfg "$1" "user.email" "$3"
    success "User set to '$name <$email>' in ${FWHITE}$1"
}

git.fetch() {
    require git
    if [ "$1" ]; then
        if git.remote_branch_exists "origin/$1"; then
            git fetch origin "refs/heads/$1:refs/remotes/origin/$1" --progress --prune --quiet 2>&1 || die "Could not fetch $1 from origin" 12
        else
            warn "Tried to fetch branch 'origin/$1' but it does not exist."
        fi
    else
        git fetch origin --progress --prune --quiet 2>&1 || exit 12
    fi
}

git.reset() {
    require git
    git reset --hard HEAD
    git clean -fd
}

git.clone() {
    require git
    git clone $* 2>&1
}

git.co() {
    require git
    git checkout $* 2>&1
}

git.is_it_current_branch() {
    require git
    [ "$1" ] || die "git.is_it_current_branch: Branch is not specified" 19
    [[ "$(git.current_branch)" = "$1" ]]
}

git.pull() {
    require git
    [ "$1" ] && BRANCH=$1 || BRANCH=$(git.current_branch)
    # note "Updating branch $BRANCH..."
    git pull origin "refs/heads/$BRANCH:refs/remotes/origin/$BRANCH" --prune --force --quiet 2>&1 || exit 13
    git pull origin --tags --force --quiet 2>&1 || exit 13
    # [ "$1" ] || die "git.pull: Branch is not specified" 19
    # if [ "$1" ]; then
        # note "Updating branch $1..."
        # git pull origin "refs/heads/$1:refs/remotes/origin/$1" --prune --force --quiet 2>&1 || exit 13
    # else
    #     note "Updating current branch..."
    #     git pull
    # fi
}

git.current_branch() {
    require git
    git branch --show-current || exit 18
}

git.local_branch_exists() {
    require git
    [ -n "$(git for-each-ref --format='%(refname:short)' refs/heads/$1)" ]
}

git.update_refs() {
    require git
    info "Updating local refs..."
    git remote update origin --prune 1>/dev/null 2>&1 || exit 18
}

git.delete_remote_branch() {
    require git
    [ "$1" ] || die "git.remote_branch_exists: Branch is not specified" 19
    if git.remote_branch_exists "origin/$1"; then
        git push origin :"$1" # || die "Could not delete the remote $1 in $ORIGIN"
        return 0
    else
        warn "Trying to delete the remote branch $1, but it does not exists in origin"
        return 1
    fi
}

git.is_clean_worktree() {
    require git
    git rev-parse --verify HEAD >/dev/null || exit 18
    git update-index -q --ignore-submodules --refresh
    git diff-files --quiet --ignore-submodules || return 1
    git diff-index --quiet --ignore-submodules --cached HEAD -- || return 2
    return 0
}

git.is_branch_merged_into() {
    require git
    [ "$1" ] || die "git.remote_branch_exists: Branch1 is not specified" 19
    [ "$2" ] || die "git.remote_branch_exists: Branch2 is not specified" 19
    git.update_refs
    local merge_hash=$(git merge-base "$1"^{} "$2"^{})
    local base_hash=$(git rev-parse "$1"^{})
    [ "$merge_hash" = "$base_hash" ]
}

git.remote_branch_exists() {
    require git
    [ "$1" ] || die "git.remote_branch_exists: Branch is not specified" 19
    git.update_refs
	[ -n "$(git for-each-ref --format='%(refname:short)' refs/remotes/$1)" ]
}

git.new_branch() {
    require git
    [ "$1" ] || die "git.new_branch: Branch is not specified" 19
    if [ "$2" ] && ! git.local_branch_exists "$2" && git.remote_branch_exists "origin/$2"; then
        git.co -b "$1" origin/"$2"
    else
        git.co -b "$1" "$2"
    fi
}

git.require_clean_worktree() {
    require git
    if ! git.is_clean_worktree; then
        warn "Your working tree is dirty! Look at this:"
        git status -bs
        _T="What should you do now?\n"
        _T="${_T}\t${BOLD}${FWHITE}0.${RESET} try to continue as is\t- errors may occur!\n"
        _T="${_T}\t${BOLD}${FWHITE}1.${RESET} hard reset\t\t\t- clear current changes and new files\n"
        _T="${_T}\t${BOLD}${FWHITE}2.${RESET} stash changes (default)\t- save all changes in safe to apply them later via 'git stash pop'\n"
        _T="${_T}\t${BOLD}${FWHITE}3.${RESET} cancel\n"
        ask "${_T}${BOLD}${FWHITE}Your choice [0-3]" reset_answer
        case $reset_answer in
            1 ) warn "Clearing your work..." && git.reset              ;;
            3 ) exit                                                   ;;
            * ) git stash -a -u -m "WIP before switch to $branch_task" ;;
        esac
    fi
}
