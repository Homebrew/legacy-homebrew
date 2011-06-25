brew-man(1) -- Generate man pages for Homebrew
==============================================

## SYNOPSIS

`brew man` [--verbose]  
`brew man` --link  
`brew man` --server  

## DESCRIPTION

Generates man pages for Homebrew using [`ronn`][ronn].

`brew man` by itself updates the man pages from the source files.

With `--link`, symlinks generated man pages to `share/man` under
the Homebrew Prefix.

With `--server`, starts ronn's dev server.


[ronn]: http://rtomayko.github.com/ronn/
        "Ronn"

## OPTIONS
  * `-v`, `--verbose`:
    Run `man brew` after generating man pages.

  * `-l`, `--link`:
    Creates symlinks from the generated man pages to the Homebrew Prefix,
    typically `/usr/local`. Useful when Homebrew itself is not installed
    directly into `/usr/local`.

  * `-s`, `--server`:
    Starts ronn's test server.

## SEE ALSO

`brew`(1)

## BUGS

See Issues on GitHub: <http://github.com/mxcl/homebrew/issues>
