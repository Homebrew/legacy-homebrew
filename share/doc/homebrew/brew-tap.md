# brew tap
The `brew tap` command is powerful, but has a few subtleties worth describing.

**tl;dr** `brew tap` allows you to add more Github repos to the list of formulae that `brew` tracks, updates and installs from. When naming tap repos and formulas, however, there are a few gotchas to beware of.

## The command

*   If you run `brew tap` with no arguments, it will list the currently
    tapped repositories. Example:

```bash
$ brew tap
homebrew/dupes
telemachus/desc
telemachus/vim
```

*   If you run `brew tap` with a single argument, `brew` will attempt to
    parse the argument into a valid 'username/repo' combination. If the argument is a valid name, then `brew tap` will attempt to clone the repository and symlink all its formulae. (See below for what it means to be a 'valid name'.) After that, `brew` will be able to work on those formulae as if there were in Homebrew's canonical repository. You can install and uninstall them with `brew [un]install`, and the formulae are automatically updated when you run `brew update`. (See below for a few exceptions on names and installation.)

*   In you run `brew tap --repair`, then `brew` will check for dead symlinks
    and relink all valid formulae across all your taps.

*   You can remove a tapped repository using the `brew untap` command.

## Naming conventions and limitations

`brew tap username/repo` employs some shortcuts and has some limitations.

*   On Github, your repository must be named `homebrew-something`.
    The prefix 'homebrew-' is not optional.

*   When you use `brew tap` on the command line, you can leave out the
    'homebrew-' prefix in commands.

    That is, `brew tap username/foobar` can be used as a shortcut for the long version: `brew tap username/homebrew-foobar`. The command will automatically add back the 'homebrew-' prefix.

## Formula duplicate names
If your tap contains a formula that is also present in master, that's fine, but it means that you must install it explicitly.

For example, you can create a tap for an alternative `vim` formula, but in that case when you install from there you must run the command with a more explicit installation target:

```bash
brew install vim                 # installs from Homebrew/homebrew
brew install username/repo/vim   # installs from your custom repo
```
