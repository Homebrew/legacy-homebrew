puts_with_style() {
  local message output_fd="$1" plain="$2" styled="$3"
  shift 3

  if [[ $# -eq 0 ]]
  then
    IFS= read -d '' -r message # Read message from `stdin`.
    message="${message%$'\n'}" # Trim trailing newline.
  else
    message="$*"
  fi

  if [[ -t "$output_fd" ]] # If FD is a TTY, style message with color/bold/...
  then
    # shellcheck disable=SC2059
    printf "$styled\n" "$message"
  else
    # shellcheck disable=SC2059
    printf "$plain\n" "$message"
  fi
}

ohai() {
  # Use bold and blue color if `stdout` is a TTY.
  puts_with_style 1 "==> %s" "\033[1;34m==>\033[1;39m %s\033[0m" "$@"
}

oh1() {
  # Use bold and green color if `stdout` is a TTY.
  puts_with_style 1 "==> %s" "\033[1;32m==>\033[1;39m %s\033[0m" "$@"
}

opoo() {
  # Use underline and yellow color if `stderr` is a TTY.
  puts_with_style 2 "Warning: %s" "\033[4;33mWarning\033[0m: %s" "$@" >&2
}

onoe() {
  # Use underline and red color if `stderr` is a TTY.
  puts_with_style 2 "Error: %s" "\033[4;31mError\033[0m: %s" "$@" >&2
}

odie() {
  # Use underline and red color if `stderr` is a TTY.
  puts_with_style 2 "Error: %s" "\033[4;31mError\033[0m: %s" "$@" >&2
  exit 1
}
