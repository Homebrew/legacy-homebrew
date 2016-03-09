odie() {
  if [[ -t 2 ]] # check whether stderr is a tty.
  then
    echo -ne "\033[4;31mError\033[0m: " >&2 # highlight Error with underline and red color
  else
    echo -n "Error: " >&2
  fi
  if [[ $# -eq 0 ]]
  then
    /bin/cat >&2
  else
    echo "$*" >&2
  fi
  exit 1
}

chdir() {
  cd "$@" >/dev/null || odie "Error: failed to cd to $*!"
}

# Force UTF-8 to avoid encoding issues for users with broken locale settings.
if [[ "$(locale charmap 2> /dev/null)" != "UTF-8" ]]
then
  export LC_ALL="en_US.UTF-8"
fi

# Where we store built products; /usr/local/Cellar if it exists,
# otherwise a Cellar relative to the Repository.
if [[ -d "$HOMEBREW_PREFIX/Cellar" ]]
then
  HOMEBREW_CELLAR="$HOMEBREW_PREFIX/Cellar"
else
  HOMEBREW_CELLAR="$HOMEBREW_REPOSITORY/Cellar"
fi

case "$*" in
  --prefix) echo "$HOMEBREW_PREFIX"; exit 0 ;;
  --cellar) echo "$HOMEBREW_CELLAR"; exit 0 ;;
  --repository|--repo) echo "$HOMEBREW_REPOSITORY"; exit 0 ;;
esac

if [[ "$HOMEBREW_PREFIX" = "/" || "$HOMEBREW_PREFIX" = "/usr" ]]
then
  # it may work, but I only see pain this route and don't want to support it
  odie "Cowardly refusing to continue at this prefix: $HOMEBREW_PREFIX"
fi

# Users may have these set, pointing the system Ruby
# at non-system gem paths
unset GEM_HOME
unset GEM_PATH

if [[ -z "$HOMEBREW_DEVELOPER" ]]
then
  unset HOMEBREW_RUBY_PATH
fi

if [[ "$(uname -s)" = "Darwin" ]]
then
  HOMEBREW_OSX="1"
fi

if [[ -z "$HOMEBREW_RUBY_PATH" ]]
then
  if [[ -n "$HOMEBREW_OSX" ]]
  then
    HOMEBREW_RUBY_PATH="/System/Library/Frameworks/Ruby.framework/Versions/Current/usr/bin/ruby"
  else
    HOMEBREW_RUBY_PATH="$(which ruby)"
  fi
fi

export HOMEBREW_BREW_FILE
export HOMEBREW_RUBY_PATH
export HOMEBREW_PREFIX
export HOMEBREW_REPOSITORY
export HOMEBREW_LIBRARY
export HOMEBREW_CELLAR

if [[ -n "$HOMEBREW_OSX" ]]
then
  if [[ "$('/usr/bin/xcode-select' --print-path)" = "/" ]]
  then
    odie <<EOS
Your xcode-select path is currently set to '/'.
This causes the 'xcrun' tool to hang, and can render Homebrew unusable.
If you are using Xcode, you should:
  sudo xcode-select -switch /Applications/Xcode.app
Otherwise, you should:
  sudo rm -rf /usr/share/xcode-select
EOS
  fi

  XCRUN_OUTPUT="$(/usr/bin/xcrun clang 2>&1)"
  XCRUN_STATUS="$?"

  if [[ "$XCRUN_STATUS" -ne 0 && "$XCRUN_OUTPUT" = *license* ]]
  then
    odie <<EOS
You have not agreed to the Xcode license. Please resolve this by running:
  sudo xcodebuild -license
EOS
  fi
fi

# Many Pathname operations use getwd when they shouldn't, and then throw
# odd exceptions. Reduce our support burden by showing a user-friendly error.
if [[ ! -d "$(pwd)" ]]
then
  odie "The current working directory doesn't exist, cannot proceed."
fi

if [[ "$1" = -v ]]
then
  # Shift the -v to the end of the parameter list
  shift
  set -- "$@" -v
fi

HOMEBREW_ARG_COUNT="$#"
HOMEBREW_COMMAND="$1"
shift
case "$HOMEBREW_COMMAND" in
  ls)          HOMEBREW_COMMAND="list";;
  homepage)    HOMEBREW_COMMAND="home";;
  -S)          HOMEBREW_COMMAND="search";;
  up)          HOMEBREW_COMMAND="update";;
  ln)          HOMEBREW_COMMAND="link";;
  instal)      HOMEBREW_COMMAND="install";; # gem does the same
  rm)          HOMEBREW_COMMAND="uninstall";;
  remove)      HOMEBREW_COMMAND="uninstall";;
  configure)   HOMEBREW_COMMAND="diy";;
  abv)         HOMEBREW_COMMAND="info";;
  dr)          HOMEBREW_COMMAND="doctor";;
  --repo)      HOMEBREW_COMMAND="--repository";;
  environment) HOMEBREW_COMMAND="--env";;
  --config)    HOMEBREW_COMMAND="config";;
esac

if [[ -f "$HOMEBREW_LIBRARY/Homebrew/cmd/$HOMEBREW_COMMAND.sh" ]] ; then
  HOMEBREW_BASH_COMMAND="$HOMEBREW_LIBRARY/Homebrew/cmd/$HOMEBREW_COMMAND.sh"
elif [[ -n "$HOMEBREW_DEVELOPER" && -f "$HOMEBREW_LIBRARY/Homebrew/dev-cmd/$HOMEBREW_COMMAND.sh" ]] ; then
  HOMEBREW_BASH_COMMAND="$HOMEBREW_LIBRARY/Homebrew/dev-cmd/$HOMEBREW_COMMAND.sh"
fi

if [[ "$(id -u)" = "0" && "$(/usr/bin/stat -f%u "$HOMEBREW_BREW_FILE")" != "0" ]]
then
  case "$HOMEBREW_COMMAND" in
    install|reinstall|postinstall|link|pin|update|upgrade|create|migrate|tap|tap-pin|switch)
      odie <<EOS
Cowardly refusing to 'sudo brew $HOMEBREW_COMMAND'
You can use brew with sudo, but only if the brew executable is owned by root.
However, this is both not recommended and completely unsupported so do so at
your own risk.
EOS
      ;;
  esac
fi

if [[ -n "$HOMEBREW_BASH_COMMAND" ]]
then
  # source rather than executing directly to ensure the entire file is read into
  # memory before it is run. This makes running a Bash script behave more like
  # a Ruby script and avoids hard-to-debug issues if the Bash script is updated
  # at the same time as being run.
  #
  # Hide shellcheck complaint:
  # shellcheck source=/dev/null
  source "$HOMEBREW_BASH_COMMAND"
  { "homebrew-$HOMEBREW_COMMAND" "$@"; exit $?; }
else
  # Unshift command back into argument list (unless argument list was empty).
  [[ "$HOMEBREW_ARG_COUNT" -gt 0 ]] && set -- "$HOMEBREW_COMMAND" "$@"
  exec "$HOMEBREW_RUBY_PATH" -W0 "$HOMEBREW_LIBRARY/brew.rb" "$@"
fi
