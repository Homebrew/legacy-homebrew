#!/bin/bash

if [ -z "$HOMEBREW_BREW_FILE" ]
then
  echo "Error: $(basename "$0") must be called from brew!" >&2
  exit 1
fi

brew() {
  "$HOMEBREW_BREW_FILE" "$@"
}

which_git() {
  local which_git
  which_git="$(which git 2>/dev/null)"
  if [ -n "$which_git" ] && [ "/usr/bin/git" = "$which_git" ]
  then
    local active_developer_dir
    active_developer_dir="$('/usr/bin/xcode-select' -print-path 2>/dev/null)"
    if [ -n "$active_developer_dir" ] && [ -x "$active_developer_dir/usr/bin/git" ]
    then
      which_git="$active_developer_dir/usr/bin/git"
    else
      which_git=""
    fi
  fi
  echo "$which_git"
}

git_init_if_necessary() {
  if ! [ -d ".git" ]
  then
    git init -q
    git config --bool core.autocrlf false
    git config remote.origin.url https://github.com/Homebrew/homebrew.git
    git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
  fi

  if git remote show origin -n | grep -q "mxcl/homebrew"
  then
    git remote set-url origin https://github.com/Homebrew/homebrew.git
    git remote set-url --delete origin ".*mxcl\/homebrew.*"
  fi
}

repo_var() {
  echo "$1" |
    sed -e "s|$HOMEBREW_PREFIX||g" \
        -e 's|Library/Taps/||g' \
        -e 's|[^a-z0-9]|_|g' |
    tr "[:lower:]" "[:upper:]"
}

upstream_branch() {
  local upstream_branch
  upstream_branch="$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null |
                     sed -e 's|refs/remotes/origin/||' )"
  [ -z "$upstream_branch" ] && upstream_branch="master"
  echo "$upstream_branch"
}

read_current_revision() {
  git rev-parse -q --verify HEAD
}

# Don't warn about QUIET_ARGS; they need to be unquoted.
# shellcheck disable=SC2086
pop_stash() {
  [ -z "$STASHED" ] && return
  git stash pop $QUIET_ARGS
  if [ -n "$HOMEBREW_VERBOSE" ]
  then
    echo "Restoring your stashed changes to $DIR:"
    git status --short --untracked-files
  fi
  unset STASHED
}

pop_stash_message() {
  [ -z "$STASHED" ] && return
  echo "To restore the stashed changes to $DIR run:"
  echo "  'cd $DIR && git stash pop'"
  unset STASHED
}

# Don't warn about QUIET_ARGS; they need to be unquoted.
# shellcheck disable=SC2086
reset_on_interrupt() {
  [ -z "$INITIAL_BRANCH" ] || git checkout "$INITIAL_BRANCH"
  git reset --hard "$INITIAL_REVISION" $QUIET_ARGS
  if [ -n "$INITIAL_BRANCH" ]
  then
    pop_stash
  else
    pop_stash_message
  fi
}

# Don't warn about QUIET_ARGS; they need to be unquoted.
# shellcheck disable=SC2086
pull() {
  local DIR="$1"
  cd "$DIR" || return
  TAP_VAR=$(repo_var "$DIR")
  unset STASHED

  # The upstream repository's default branch may not be master;
  # check refs/remotes/origin/HEAD to see what the default
  # origin branch name is, and use that. If not set, fall back to "master".
  INITIAL_BRANCH="$(git symbolic-ref --short HEAD 2>/dev/null)"
  UPSTREAM_BRANCH="$(upstream_branch)"

  if [ -n "$(git status --untracked-files=all --porcelain 2>/dev/null)" ]
  then
    if [ -n "$HOMEBREW_VERBOSE" ]
    then
      echo "Stashing uncommitted changes to $DIR."
      git status --short --untracked-files=all
    fi
    git -c "user.email=brew-update@localhost" \
        -c "user.name=brew update" \
        stash save --include-untracked $QUIET_ARGS
    git reset --hard $QUIET_ARGS
    STASHED="1"
  fi

  # Used for testing purposes, e.g., for testing formula migration after
  # renaming it in the currently checked-out branch. To test run
  # "brew update --simulate-from-current-branch"
  if [ -n "$HOMEBREW_SIMULATE_FROM_CURRENT_BRANCH" ]
  then
    INITIAL_REVISION="$(git rev-parse -q --verify "$(upstream_branch)")"
    CURRENT_REVISION="$(read_current_revision)"
    export HOMEBREW_UPDATE_AFTER"$TAP_VAR"="$(git rev-parse "$UPSTREAM_BRANCH")"
    if ! git merge-base --is-ancestor "$INITIAL_REVISION" "$CURRENT_REVISION"
    then
      echo "Your HEAD is not a descendant of $UPSTREAM_BRANCH!" >&2
      exit 1
    fi
    return
  fi

  if [ "$INITIAL_BRANCH" != "$UPSTREAM_BRANCH" ] && [ -n "$INITIAL_BRANCH" ]
  then
    # Recreate and check out `#{upstream_branch}` if unable to fast-forward
    # it to `origin/#{@upstream_branch}`. Otherwise, just check it out.
    if git merge-base --is-ancestor "$UPSTREAM_BRANCH" "origin/$UPSTREAM_BRANCH" &>/dev/null
    then
      git checkout --force "$UPSTREAM_BRANCH" $QUIET_ARGS
    else
      git checkout --force -B "$UPSTREAM_BRANCH" "origin/$UPSTREAM_BRANCH" $QUIET_ARGS
    fi
  fi

  INITIAL_REVISION="$(read_current_revision)"

  # ensure we don't munge line endings on checkout
  git config core.autocrlf false

  trap reset_on_interrupt SIGINT

  if [ -n "$HOMEBREW_REBASE" ]
  then
    git rebase $QUIET_ARGS "origin/$UPSTREAM_BRANCH"
  else
    git merge --no-edit --ff $QUIET_ARGS "origin/$UPSTREAM_BRANCH"
  fi

  trap - SIGINT

  CURRENT_REVISION="$(read_current_revision)"
  export HOMEBREW_UPDATE_AFTER"$TAP_VAR"="$(git rev-parse "$UPSTREAM_BRANCH")"

  if [ "$INITIAL_BRANCH" != "$UPSTREAM_BRANCH" ] && [ -n "$INITIAL_BRANCH" ]
  then
    git checkout "$INITIAL_BRANCH" $QUIET_ARGS
    pop_stash
  else
    pop_stash_message
  fi
}

update-bash() {
  if [ -z "$HOMEBREW_DEVELOPER" ]
  then
    echo "This command is currently only for Homebrew developers' use." >&2
    exit 1
  fi

  for i in "$@"
  do
    case "$i" in
      update|update-bash) shift ;;
      --help) brew update --help; exit $? ;;
      --verbose) HOMEBREW_VERBOSE=1 ;;
      --debug) HOMEBREW_DEBUG=1;;
      --rebase) HOMEBREW_REBASE=1 ;;
      --simulate-from-current-branch) HOMEBREW_SIMULATE_FROM_CURRENT_BRANCH=1 ;;
      --*) ;;
      -*v*) HOMEBREW_VERBOSE=1 ;;
      -*v*) HOMEBREW_DEBUG=1 ;;
      -*) ;;
      *)
        echo "This command updates brew itself, and does not take formula names." >&2
        echo "Use 'brew upgrade <formula>'." >&2
        exit 1
        ;;
    esac
  done

  if [ -n "$HOMEBREW_DEBUG" ]
  then
    set -x
  fi

  # check permissions
  if [ "$HOMEBREW_PREFIX" = "/usr/local" ] && ! test -w /usr/local
  then
    echo "Error: /usr/local must be writable!" >&2
    exit 1
  fi

  if ! test -w "$HOMEBREW_REPOSITORY"
  then
    echo "Error: $HOMEBREW_REPOSITORY must be writable!" >&2
    exit 1
  fi

  if [ -z "$(which_git)" ]
  then
    brew install git
    if [ -z "$(which_git)" ]
    then
      echo "Error: Git must be installed and in your PATH!" >&2
      exit 1
    fi
  fi

  if [ -z "$HOMEBREW_VERBOSE" ]
  then
    QUIET_ARGS="-q"
  fi

  # ensure GIT_CONFIG is unset as we need to operate on .git/config
  unset GIT_CONFIG

  cd "$HOMEBREW_REPOSITORY" || {
    echo "Error: failed to cd to $HOMEBREW_REPOSITORY!" >&2
    exit 1
  }
  git_init_if_necessary

  for DIR in "$HOMEBREW_REPOSITORY" "$HOMEBREW_LIBRARY"/Taps/*/*
  do
    [ -d "$DIR/.git" ] || continue
    cd "$DIR" || continue
    TAP_VAR=$(repo_var "$DIR")
    export HOMEBREW_UPDATE_BEFORE"$TAP_VAR"="$(git rev-parse "$(upstream_branch)")"
    UPSTREAM_BRANCH="$(upstream_branch)"
    # the refspec ensures that the default upstream branch gets updated
    git fetch $QUIET_ARGS origin \
      "refs/heads/$UPSTREAM_BRANCH:refs/remotes/origin/$UPSTREAM_BRANCH" &
  done

  wait

  for DIR in "$HOMEBREW_REPOSITORY" "$HOMEBREW_LIBRARY"/Taps/*/*
  do
    [ -d "$DIR/.git" ] || continue
    pull "$DIR"
  done

  cd "$HOMEBREW_REPOSITORY" || {
    echo "Error: failed to cd to $HOMEBREW_REPOSITORY!" >&2
    exit 1
  }

  brew update-report "$@"
  return $?
}
