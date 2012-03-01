brew-tap(1) -- Multi-Repository Support for Homebrew
====================================================

## SYNOPSIS

`brew tap` list

`brew tap` update

`brew tap` add <repository>

`brew tap` remove <repository>

`brew tap` which <formulae>...

`brew tap` <brew_command> [--options] [<formulae>...]

## DESCRIPTION

A tool for managing repositories containing alternative Homebrew formulae and
making those formulae available to standard `brew` commands like `install`.

`brew-tap` is currently designed to access the fork network of Adam
Vandenberg's Homebrew-Alt network:

<https://github.com/adamv/homebrew-alt/network>

## COMMANDS

  * `list`:
    List all repositories that have been locally cloned and whose formulae are
    available for brewing.  Also list all repositories in the Homebrew-Alt
    network that can be cloned using `brew tap add`.

  * `update`:
    Update all cloned repositories and rescan the Homebrew-Alt network to
    refresh the information provided by `brew tap list`.

  * `add` <repository>:
    Clone a repository so that the formulae it contains will be accessable to
    other `brew tap` subcommands. <repository> is the name given by `brew tap
    list` but case-sensitive partial matching is also used. See examples
    section for details on partial matching.

  * `remove` <repository>:
    Remove a cloned repository from the system. <repository> follows the
    same rules outlined above for `brew tap add`

  * `which` <formulae>...:
    Resolve one or more formula names to brewfiles within cloned repositories
    and print the paths to the brewfiles.

  * <brew_command> [--options] [<formulae>...]:
    Where <brew_command> is a `brew` subcommand such as `install`.  Any
    subcommand can be specified, but some may not work. Formula names will be
    resolved to paths within cloned repositories. `brew` is then called to
    invoke <brew_command> with the resolved paths and the contents of
    [--options]. See examples section for details.

## EXAMPLES

###REPOSITORY NAMES
Case-sensitive partial matching is used by `brew tap add` and `brew tap remove`
so the following are equivalent:

    brew tap add adamv-homebrew-alt
    brew tap add adamv

But the following will fail:

    brew tap add Adamv

###FORMULAE NAMES
When `brew-tap` recalls a `brew` subcommand, a more complicated form of pattern
matching and expansion is used to locate brewfiles. For example, the simple
call:

    brew tap install --verbose vim

May result in the following call to `brew`:

    brew install --verbose TAPROOM_PATH/adamv-homebrew-alt/duplicates/vim.rb

For cases where multiple repositories provide a formula with the same name,
formulae may be specified using a path-like notation:

    repository/[optional/subdirectories]/formula

    brew tap install adamv/vim
    brew tap install adamv/dup/vim

Case-sensitive partial matching is used, so the first call restricts
searches for the vim formula to the adamv-homebrew-alt repository while the
second call restricts the search even further to the subdirectory
adamv-homebrew-alt/duplicates.

## SEE ALSO

`brew`(1)

## AUTHORS

Charlie Sharpsteen

## BUGS

Bugs in `brew-tap` may be reported using the GitHub issue tracker:
<http://github.com/Sharpie/homebrew/issues>

