# brew tap

`brew tap` adds more repos to the list of formulae that `brew` tracks, updates,
and installs from. By default, `tap` assumes that the repos come from GitHub,
but the command isn't limited to any one location.

## The command

* `brew tap` without arguments lists the currently tapped repositories. For
  example:

```bash
$ brew tap
homebrew/dupes
mistydemeo/tigerbrew
edavis/emacs
```

* `brew tap <user/repo>` makes a shallow clone of the repository at
  https://github.com/user/repo. After that, `brew` will be able to work on
  those formulae as if there were in Homebrew's canonical repository. You can
  install and uninstall them with `brew [un]install`, and the formulae are
  automatically updated when you run `brew update`. (See below for details
  about how `brew tap` handles the names of repositories.)

* `brew tap <user/repo> <URL>` makes a shallow clone of the repository at URL.
  Unlike the one-argument version, URL is not assumed to be GitHub, and it
  doesn't have to be HTTP. Any location and any protocol that git can handle is
  fine.

* Add `--full` to either the one- or two-argument invocations above, and git
  will make a complete clone rather than a shallow one.

* `brew tap --repair` migrates tapped formulae from symlink-based to
  directory-based structure. (This should only need to be run once.)

* `brew untap user/repo [user/repo user/repo ...]` removes the given taps. The
  repos are deleted and `brew` will no longer be aware of its formulae. `brew
  untap` can handle multiple removals at once.

## Repository naming conventions and assumptions

* On GitHub, your repository must be named `homebrew-something` in order to use
  the one-argument form of `brew tap`.  The prefix 'homebrew-' is not optional.
  (The two-argument form doesn't have this limitation, but it forces you to
  give the full URL explicitly.)

* When you use `brew tap` on the command line, however, you can leave out the
  'homebrew-' prefix in commands.

  That is, `brew tap username/foobar` can be used as a shortcut for the long
  version: `brew tap username/homebrew-foobar`. `brew` will automatically add
  back the 'homebrew-' prefix whenever it's necessary.

## Formula duplicate names

If your tap contains a formula that is also present in master, that's fine,
but it means that you must install it explicitly by default.

If you would like to prioritize a tap over master, you can use
`brew tap-pin username/repo` to pin the tap,
and use `brew tap-unpin username/repo` to revert the pin.

Whenever a `brew install foo` command is issued, brew will find which formula
to use by searching in the following order:

* Pinned taps
* Core formulae
* Other taps

If you need a formula to be installed from a particular tap, you can use fully
qualified names to refer to them.

For example, you can create a tap for an alternative `vim` formula. Without
pinning it, the behavior will be

```bash
brew install vim                     # installs from Homebrew/homebrew
brew install username/repo/vim       # installs from your custom repo
```

However if you pin the tap with `brew tap-pin username/repo`, you will need to
use `homebrew/homebrew` to refer to the core formula.

```bash
brew install vim                     # installs from your custom repo
brew install homebrew/homebrew/vim   # installs from Homebrew/homebrew
```

Do note that pinned taps are prioritized only when the formula name is directly
given by you. i.e., it will not influence formulae automatically installed as
dependencies.
