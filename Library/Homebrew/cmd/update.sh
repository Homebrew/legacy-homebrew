brew() {
  "$HOMEBREW_BREW_FILE" "$@"
}

git() {
  [[ -n "$HOMEBREW_GIT" ]] || odie "HOMEBREW_GIT is unset!"
  "$HOMEBREW_GIT" "$@"
}

which_git() {
  local git_path
  local active_developer_dir

  if [[ -n "$HOMEBREW_GIT" ]]
  then
    git_path="$HOMEBREW_GIT"
  elif [[ -n "$GIT" ]]
  then
    git_path="$GIT"
  else
    git_path="git"
  fi

  git_path="$(which "$git_path" 2>/dev/null)"

  if [[ -n "$git_path" ]]
  then
    git_path="$(chdir "${git_path%/*}" && pwd -P)/${git_path##*/}"
  fi

  if [[ -n "$HOMEBREW_OSX" && "$git_path" = "/usr/bin/git" ]]
  then
    active_developer_dir="$('/usr/bin/xcode-select' -print-path 2>/dev/null)"
    if [[ -n "$active_developer_dir" && -x "$active_developer_dir/usr/bin/git" ]]
    then
      git_path="$active_developer_dir/usr/bin/git"
    else
      git_path=""
    fi
  fi
  echo "$git_path"
}

git_init_if_necessary() {
  set -e
  trap '{ rm -rf .git; exit 1; }' EXIT

  if [[ ! -d ".git" ]]
  then
    git init
    git config --bool core.autocrlf false
    git config remote.origin.url https://github.com/Homebrew/homebrew.git
    git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
    git fetch origin
    git reset --hard origin/master
    SKIP_FETCH_HOMEBREW_REPOSITORY=1
  fi

  set +e
  trap - EXIT

  if [[ "$(git remote show origin -n)" = *"mxcl/homebrew"* ]]
  then
    git remote set-url origin https://github.com/Homebrew/homebrew.git &&
    git remote set-url --delete origin ".*mxcl\/homebrew.*"
  fi
}

rename_taps_dir_if_necessary() {
  local tap_dir
  local tap_dir_basename
  local user
  local repo

  for tap_dir in "$HOMEBREW_LIBRARY"/Taps/*
  do
    [[ -d "$tap_dir/.git" ]] || continue
    tap_dir_basename="${tap_dir##*/}"
    if [[ "$tap_dir_basename" = *"-"* ]]
    then
      # only replace the *last* dash: yes, tap filenames suck
      user="$(echo "${tap_dir_basename%-*}" | tr "[:upper:]" "[:lower:]")"
      repo="$(echo "${tap_dir_basename:${#user}+1}" | tr "[:upper:]" "[:lower:]")"
      mkdir -p "$HOMEBREW_LIBRARY/Taps/$user"
      mv "$tap_dir", "$HOMEBREW_LIBRARY/Taps/$user/homebrew-$repo"

      if [[ ${#${tap_dir_basename//[^\-]}} -gt 1 ]]
      then
        echo "Homebrew changed the structure of Taps like <someuser>/<sometap>." >&2
        echo "So you may need to rename $HOMEBREW_LIBRARY/Taps/$user/homebrew-$repo manually." >&2
      fi
    else
      echo "Homebrew changed the structure of Taps like <someuser>/<sometap>. " >&2
      echo "$tap_dir is an incorrect Tap path." >&2
      echo "So you may need to rename it to $HOMEBREW_LIBRARY/Taps/<someuser>/homebrew-<sometap> manually." >&2
    fi
  done
}

repo_var() {
  local repo_var

  repo_var="$1"
  if [[ "$repo_var" = "$HOMEBREW_REPOSITORY" ]]
  then
    repo_var=""
  else
    repo_var="${repo_var#"$HOMEBREW_LIBRARY/Taps"}"
    repo_var="$(echo -n "$repo_var" | tr -C "A-Za-z0-9" "_" | tr "[:lower:]" "[:upper:]")"
  fi
  echo "$repo_var"
}

upstream_branch() {
  local upstream_branch

  upstream_branch="$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null)"
  upstream_branch="${upstream_branch#refs/remotes/origin/}"
  [[ -z "$upstream_branch" ]] && upstream_branch="master"
  echo "$upstream_branch"
}

read_current_revision() {
  git rev-parse -q --verify HEAD
}

pop_stash() {
  [[ -z "$STASHED" ]] && return
  git stash pop "${QUIET_ARGS[@]}"
  if [[ -n "$HOMEBREW_VERBOSE" ]]
  then
    echo "Restoring your stashed changes to $DIR:"
    git status --short --untracked-files
  fi
  unset STASHED
}

pop_stash_message() {
  [[ -z "$STASHED" ]] && return
  echo "To restore the stashed changes to $DIR run:"
  echo "  'cd $DIR && git stash pop'"
  unset STASHED
}

reset_on_interrupt() {
  if [[ "$INITIAL_BRANCH" != "$UPSTREAM_BRANCH" && -n "$INITIAL_BRANCH" ]]
  then
    git checkout "$INITIAL_BRANCH"
  fi

  if [[ -n "$INITIAL_REVISION" ]]
  then
    git reset --hard "$INITIAL_REVISION" "${QUIET_ARGS[@]}"
  fi

  if [[ "$INITIAL_BRANCH" != "$UPSTREAM_BRANCH" && -n "$INITIAL_BRANCH" ]]
  then
    pop_stash
  else
    pop_stash_message
  fi

  exit 130
}

pull() {
  local DIR
  local TAP_VAR

  DIR="$1"
  cd "$DIR" || return
  TAP_VAR=$(repo_var "$DIR")
  unset STASHED

  # The upstream repository's default branch may not be master;
  # check refs/remotes/origin/HEAD to see what the default
  # origin branch name is, and use that. If not set, fall back to "master".
  INITIAL_BRANCH="$(git symbolic-ref --short HEAD 2>/dev/null)"
  UPSTREAM_BRANCH="$(upstream_branch)"

  # Used for testing purposes, e.g., for testing formula migration after
  # renaming it in the currently checked-out branch. To test run
  # "brew update --simulate-from-current-branch"
  if [[ -n "$HOMEBREW_SIMULATE_FROM_CURRENT_BRANCH" ]]
  then
    INITIAL_REVISION="$(git rev-parse -q --verify "$UPSTREAM_BRANCH")"
    CURRENT_REVISION="$(read_current_revision)"
    export HOMEBREW_UPDATE_BEFORE"$TAP_VAR"="$INITIAL_REVISION"
    export HOMEBREW_UPDATE_AFTER"$TAP_VAR"="$CURRENT_REVISION"
    if ! git merge-base --is-ancestor "$INITIAL_REVISION" "$CURRENT_REVISION"
    then
      odie "Your $DIR HEAD is not a descendant of $UPSTREAM_BRANCH!"
    fi
    return
  fi

  trap reset_on_interrupt SIGINT

  if [[ -n "$(git status --untracked-files=all --porcelain 2>/dev/null)" ]]
  then
    if [[ -n "$HOMEBREW_VERBOSE" ]]
    then
      echo "Stashing uncommitted changes to $DIR."
      git status --short --untracked-files=all
    fi
    git merge --abort &>/dev/null
    git -c "user.email=brew-update@localhost" \
        -c "user.name=brew update" \
        stash save --include-untracked "${QUIET_ARGS[@]}"
    git reset --hard "${QUIET_ARGS[@]}"
    STASHED="1"
  fi

  if [[ "$INITIAL_BRANCH" != "$UPSTREAM_BRANCH" && -n "$INITIAL_BRANCH" ]]
  then
    # Recreate and check out `#{upstream_branch}` if unable to fast-forward
    # it to `origin/#{@upstream_branch}`. Otherwise, just check it out.
    if git merge-base --is-ancestor "$UPSTREAM_BRANCH" "origin/$UPSTREAM_BRANCH" &>/dev/null
    then
      git checkout --force "$UPSTREAM_BRANCH" "${QUIET_ARGS[@]}"
    else
      git checkout --force -B "$UPSTREAM_BRANCH" "origin/$UPSTREAM_BRANCH" "${QUIET_ARGS[@]}"
    fi
  fi

  INITIAL_REVISION="$(read_current_revision)"
  export HOMEBREW_UPDATE_BEFORE"$TAP_VAR"="$INITIAL_REVISION"

  # ensure we don't munge line endings on checkout
  git config core.autocrlf false

  if [[ -n "$HOMEBREW_REBASE" ]]
  then
    git rebase "${QUIET_ARGS[@]}" "origin/$UPSTREAM_BRANCH"
  else
    git merge --no-edit --ff "${QUIET_ARGS[@]}" "origin/$UPSTREAM_BRANCH" \
      --strategy=recursive \
      --strategy-option=ours \
      --strategy-option=ignore-all-space
  fi

  export HOMEBREW_UPDATE_AFTER"$TAP_VAR"="$(read_current_revision)"

  trap '' SIGINT

  pop_stash_message

  trap - SIGINT
}

homebrew-update() {
  local option
  local DIR
  local UPSTREAM_BRANCH

  for option in "$@"
  do
    case "$option" in
      # TODO: - `brew update --help` should display update subcommand help
      --help) brew --help; exit $? ;;
      --verbose) HOMEBREW_VERBOSE=1 ;;
      --debug) HOMEBREW_DEBUG=1;;
      --rebase) HOMEBREW_REBASE=1 ;;
      --simulate-from-current-branch) HOMEBREW_SIMULATE_FROM_CURRENT_BRANCH=1 ;;
      --*) ;;
      -*)
        [[ "$option" = *v* ]] && HOMEBREW_VERBOSE=1;
        [[ "$option" = *d* ]] && HOMEBREW_DEBUG=1;
        ;;
      *)
        odie <<-EOS
This command updates brew itself, and does not take formula names.
Use 'brew upgrade <formula>'.
EOS
        ;;
    esac
  done

  if [[ -n "$HOMEBREW_DEBUG" ]]
  then
    set -x
  fi

  # check permissions
  if [[ "$HOMEBREW_PREFIX" = "/usr/local" && ! -w /usr/local ]]
  then
    odie "/usr/local must be writable!"
  fi

  if [[ ! -w "$HOMEBREW_REPOSITORY" ]]
  then
    odie "$HOMEBREW_REPOSITORY must be writable!"
  fi

  HOMEBREW_GIT="$(which_git)"
  if [[ -z "$HOMEBREW_GIT" ]]
  then
    brew install git
    HOMEBREW_GIT="$(which_git)"
    if [[ -z "$HOMEBREW_GIT" ]]
    then
      odie "Git must be installed and in your PATH!"
    fi
  fi
  export GIT_TERMINAL_PROMPT="0"
  export GIT_ASKPASS="false"
  export GIT_SSH_COMMAND="ssh -oBatchMode=yes"

  if [[ -z "$HOMEBREW_VERBOSE" ]]
  then
    QUIET_ARGS=(-q)
  else
    QUIET_ARGS=()
  fi

  # ensure GIT_CONFIG is unset as we need to operate on .git/config
  unset GIT_CONFIG

  chdir "$HOMEBREW_REPOSITORY"
  git_init_if_necessary
  # rename Taps directories
  # this procedure will be removed in the future if it seems unnecessary
  rename_taps_dir_if_necessary

  # kill all of subprocess on interrupt
  trap '{ pkill -P $$; wait; exit 130; }' SIGINT

  for DIR in "$HOMEBREW_REPOSITORY" "$HOMEBREW_LIBRARY"/Taps/*/*
  do
    [[ -d "$DIR/.git" ]] || continue
    [[ -n "$SKIP_FETCH_HOMEBREW_REPOSITORY" && "$DIR" = "$HOMEBREW_REPOSITORY" ]] && continue
    cd "$DIR" || continue
    UPSTREAM_BRANCH="$(upstream_branch)"
    # the refspec ensures that the default upstream branch gets updated
    (
      UPSTREAM_REPOSITORY_URL="$(git config remote.origin.url)"
      if [[ "$UPSTREAM_REPOSITORY_URL" = "https://github.com/"* ]]
      then
        UPSTREAM_REPOSITORY="${UPSTREAM_REPOSITORY_URL#https://github.com/}"
        UPSTREAM_REPOSITORY="${UPSTREAM_REPOSITORY%.git}"
        UPSTREAM_BRANCH_LOCAL_SHA="$(git rev-parse "refs/remotes/origin/$UPSTREAM_BRANCH")"
        # Only try to `git fetch` when the upstream branch is at a different SHA
        # (so the API does not return 304: unmodified).
        UPSTREAM_SHA_HTTP_CODE="$(curl --silent '--max-time' 3 \
           --output /dev/null --write-out "%{http_code}" \
           -H "Accept: application/vnd.github.chitauri-preview+sha" \
           -H "If-None-Match: \"$UPSTREAM_BRANCH_LOCAL_SHA\"" \
           "https://api.github.com/repos/$UPSTREAM_REPOSITORY/commits/$UPSTREAM_BRANCH")"
        [[ "$UPSTREAM_SHA_HTTP_CODE" = "304" ]] && exit
      fi

      git fetch "${QUIET_ARGS[@]}" origin \
        "refs/heads/$UPSTREAM_BRANCH:refs/remotes/origin/$UPSTREAM_BRANCH" || \
          odie "Fetching $DIR failed!"
    ) &
  done

  wait
  trap - SIGINT

  for DIR in "$HOMEBREW_REPOSITORY" "$HOMEBREW_LIBRARY"/Taps/*/*
  do
    [[ -d "$DIR/.git" ]] || continue
    pull "$DIR"
  done

  chdir "$HOMEBREW_REPOSITORY"
  brew update-report "$@"
  return $?
}
