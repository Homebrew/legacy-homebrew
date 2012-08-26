brew(1) -- The missing package manager for OS X
===============================================

## SYNOPSIS

`brew` --version  
`brew` [--verbose|-v] command [options] [formula] ...

## DESCRIPTION

Homebrew is the easiest and most flexible way to install the UNIX tools Apple
didn't include with OS X.

## OPTIONS
  * `-v`, `--verbose` command [options] [formula] ...:
    With `--verbose`, many commands print extra debugging information.

## ESSENTIAL COMMANDS

For the full command list, see the COMMANDS section.

  * `install` <formula>:
    Install <formula>.

  * `remove` <formula>:
    Uninstall <formula>.

  * `update`:
    Fetch the newest version of Homebrew from GitHub using `git`(1).

  * `list`:
    List all installed formulae.

  * `search`, `-S` <text>|/<text>/:
    Perform a substring search of formula names for <text>. If <text> is
    surrounded with slashes, then it is interpreted as a regular expression.
    If no search term is given, all available formula are displayed.

## COMMANDS

  * `audit` [<formulae>]:
    Check <formulae> for Homebrew coding style violations. This should be
    run before submitting a new formula.

    If no <formulae> are provided, all of them are checked.

    `audit` exits with a non-zero status if any errors are found. This is useful,
    for instance, for implementing pre-commit hooks.

  * `cat` <formula>:
    Display the source to <formula>.

  * `cleanup [--force] [-ns]` [<formulae>]:
    For all installed or specific formulae, remove any older versions from the
    cellar. By default, does not remove out-of-date keg-only brews, as other
    software may link directly to specific versions. In addition old downloads from
    the Homebrew download-cache are deleted.

    If `--force` is passed, remove out-of-date keg-only brews as well.

    If `-n` is passed, show what would be removed, but do not actually remove anything.

    If `-s` is passed, scrubs the cache, removing downloads for even the latest
    versions of formula. Note downloads for any installed formula will still not be
    deleted. If you want to delete those too: `rm -rf $(brew --cache)`

  * `create [--autotools|--cmake] [--no-fetch]` <URL>:
    Generate a formula for the downloadable file at <URL> and open it in
    `EDITOR`. Homebrew will attempt to automatically derive the formula name
    and version, but if it fails, you'll have to make your own template. The wget
    formula serves as a simple example.

    If `--autotools` is passed, create a basic template for an Autotools-style build.
    If `--cmake` is passed, create a basic template for a CMake-style build.

    If `--no-fetch` is passed, Homebrew will not download <URL> to the cache and
    will thus not add the MD5 to the formula for you.

  * `deps [--1] [-n] [--tree] [--all]` <formula>:
    Show <formula>'s dependencies.

    If `--1` is passed, only show dependencies one level down, instead of
    recursing.

    If `-n` is passed, show dependencies in topological order.

    If `--tree` is passed, show dependencies as a tree.

    If `--all` is passed, show dependencies for all formulae.

  * `diy [--set-name] [--set-version]`:
    Automatically determine the installation prefix for non-Homebrew software.

    Using the output from this command, you can install your own software into
    the Cellar and then link it into Homebrew's prefix with `brew link`.

    The options `--set-name` and `--set-version` each take an argument and allow
    you to explicitly set the name and version of the package you are installing.

  * `doctor`:
    Check your system for potential problems. Doctor exits with a non-zero status
    if any problems are found.

  * `edit`:
    Open all of Homebrew for editing.

  * `edit` <formula>:
    Open <formula> in `EDITOR`.

  * `fetch [--force] [-v] [--HEAD] [--deps]` <formulae>:
    Download the source packages for the given <formulae>.
    For tarballs, also print MD5 and SHA1 checksums.

    If `--HEAD` is passed, download the HEAD versions of <formulae> instead. `-v`
    may also be passed to make the VCS checkout verbose, useful for seeing if
    an existing HEAD cache has been updated.

    If `--force` is passed, remove a previously cached version and re-fetch.

    If `--deps` is passed, also download dependencies for any listed <formulae>.

  * `home`:
    Open Homebrew's own homepage in a browser.

  * `home` <formula>:
    Open <formula>'s homepage in a browser.

  * `info [--all]` <formula>:
    Display information about <formula>.

    If `--all` is passed, show info for all formulae.

  * `info --github` <formula>:
    Open a browser to the GitHub History page for formula <formula>.

    To view formula history locally: `brew log -p <formula>`.

  * `info` <URL>:
    Print the name and version that will be detected for <URL>.

  * `install [--force] [--debug] [--ignore-dependencies] [--fresh] [--use-clang] [--use-gcc] [--use-llvm] [--build-from-source] [--devel] [--HEAD]` <formula>:
    Install <formula>.

    <formula> is usually the name of the formula to install, but it can be specified
    several different ways. See [SPECIFYING FORMULAE][].

    If `--force` is passed, will install <formula> if it exists, even if it
    is blacklisted.

    If `--debug` is passed and brewing fails, open a shell inside the
    temporary directory used for compiling.

    If `--ignore-dependencies` is passed, skip installing any dependencies of
    any kind. If they are not already present, the formula will probably fail
    to install.

    If `--fresh` is passed, the installation process will not re-use any
    options from previous installs.

    If `--use-clang` is passed, attempt to compile using clang.

    If `--use-gcc` is passed, attempt to compile using GCC. This is useful for
    systems whose default compiler is LLVM-GCC.

    If `--use-llvm` is passed, attempt to compile using the LLVM front-end to GCC.
    *NOTE*: Not all formulae will build with LLVM.

    If `--build-from-source` is passed, compile from source even if a bottle
    is provided for <formula>.

    If `--devel` is passed, and <formula> defines it, install the development version.

    If `--HEAD` is passed, and <formula> defines it, install the HEAD version,
    aka master, trunk, unstable.

    To install a newer version of HEAD use
    `brew rm <foo> && brew install --HEAD <foo>`
    or `brew install --force --HEAD <foo>`.

  * `install --interactive [--git]` <formula>:
    Download and patch <formula>, then open a shell. This allows the user to
    run `./configure --help` and otherwise determine how to turn the software
    package into a Homebrew formula.

    If `--git` is passed, Homebrew will create a Git repository, useful for
    creating patches to the software.

  * `ln`, `link [--force] [--dry-run]` <formula>:
    Symlink all of <formula>'s installed files into the Homebrew prefix. This
    is done automatically when you install formula, but can be useful for DIY
    installations.

    If `--force` is passed, Homebrew will delete files which already exist in
    the prefix while linking.

    If `--dry-run` or `-n` is passed, Homebrew will list all files which would
    be deleted by `brew link --force`, but will not actually link or delete
    any files.

  * `ls, list [--unbrewed] [--versions]` [<formulae>]:
    Without any arguments, list all installed formulae.

    If <formulae> are given, list the installed files for <formulae>.
    Combined with `--verbose`, recursively list the contents of all subdirectories
    in each <formula>'s keg.

    If `--unbrewed` is passed, list all files in the Homebrew prefix not installed
    by Homebrew.

    If `--versions` is passed, show the version number for installed formulae,
    or only the specified formulae if <formulae> are given.

  * `log [git-log-options]` <formula> ...:
    Show the git log for the given formulae. Options that `git-log`(1)
    recognizes can be passed before the formula list.

  * `missing` [<formulae>]:
    Check the given <formulae> for missing dependencies.

    If no <formulae> are given, check all installed brews.

  * `options [--compact] [--all] [--installed]` <formula>:
    Display install options specific to <formula>.

    If `--compact` is passed, show all options on a single line separated by
    spaces.

    If `--all` is passed, show options for all formulae.

    If `--installed` is passed, show options for all installed formulae.

  * `outdated [--quiet]`:
    Show formulae that have an updated version available.

    If `--quiet` is passed, list only the names of outdated brews. Otherwise,
    the versions are printed as well.

  * `prune`:
    Remove dead symlinks from the Homebrew prefix. This is generally not
    needed, but can be useful when doing DIY installations.

  * `rm`, `remove`, `uninstall [--force]` <formula>:
    Uninstall <formula>.

    If `--force` is passed, and there are multiple versions of <formula>
    installed, delete all installed versions.

  * `search`, `-S` <text>|/<text>/:
    Perform a substring search of formula names for <text>. If <text> is
    surrounded with slashes, then it is interpreted as a regular expression.
    If no search term is given, all available formula are displayed.

  * `search --macports`|`--fink` <text>:
    Search for <text> on the MacPorts or Fink package search page.

  * `tap` [<tap>]:
    Tap a new formula repository from GitHub, or list existing taps.

    <tap> is of the form <user>/<repo>, e.g. `brew tap homebrew/dupes`.

  * `tap --repair`:

    Ensures all tapped formula are symlinked into Library/Formula and prunes dead
    formula from Library/Formula.

  * `test` <formula>:
    A few formulae provide a test method. `brew test <formula>` runs this
    test method. There is no standard output or return code, but it should
    generally indicate to the user if something is wrong with the installed
    formula.

    Example: `brew install jruby && brew test jruby`

  * `unlink` <formula>:
    Unsymlink <formula> from the Homebrew prefix. This can be useful for
    temporarily disabling a formula: `brew unlink foo && commands && brew link foo`.

  * `untap` <tap>:
    Remove a tapped repository.

  * `update [--rebase]`:
    Fetch the newest version of Homebrew and all formulae from GitHub using
     `git`(1).

    If `--rebase` is specified then `git pull --rebase` is used.

  * `upgrade` [<formulae>]:
    Upgrade outdated brews.

    If <formulae> are given, upgrade only the specified brews.

  * `uses [--installed]` <formula>:
    Show the formulas that specify <formula> as a dependency. The list is
    not recursive; only one level of dependencies is resolved.

    If `--installed` is passed, only list installed formulae.

  * `versions [--compact]` <formulae>:
    List previous versions of <formulae>, along with a command to checkout
    each version.

    If `--compact` is passed, show all options on a single line separated by
    spaces.

  * `--cache`:
    Display Homebrew's download cache. *Default:* `~/Library/Caches/Homebrew`

  * `--cache` <formula>:
    Display the file or directory used to cache <formula>.

  * `--cellar`:
    Display Homebrew's Cellar path. *Default:* `/usr/local/Cellar`

  * `--cellar` <formula>:
    Display the location in the cellar where <formula> would be installed,
    without any sort of versioned directory as the last path.

  * `--config`:
    Show Homebrew and system configuration useful for debugging. If you file
    a bug report, you will likely be asked for this information if you do not
    provide it.

  * `--prefix`:
    Display Homebrew's install path. *Default:* `/usr/local`

  * `--prefix` <formula>:
    Display the location in the cellar where <formula> is or would be installed.

  * `--repository`:
    Display where Homebrew's `.git` directory is located. For standard installs,
    the `prefix` and `repository` are the same directory.

  * `--version`:
    Print the version number of brew to standard error and exit.

## EXTERNAL COMMANDS

Homebrew, like `git`(1), supports external commands. These are executable
scripts that reside somewhere in the PATH, named `brew-<cmdname>` or
`brew-<cmdname>.rb`, which can be invoked like `brew cmdname`. This allows you
to create your own commands without modifying Homebrew's internals.

A number of (useful, but unsupported) external commands are included and enabled
by default:

    $ ls `brew --repository`/Library/Contributions/cmds

Documentation for the included external commands as well as instructions for
creating your own can be found on the wiki:
<http://wiki.github.com/mxcl/homebrew/External-Commands>

## SPECIFYING FORMULAE

Many Homebrew commands accept one or more <formula> arguments. These arguments
can take several different forms:

  * The name of a formula:
    e.g. `git`, `node`, `wget`.

  * The fully-qualified name of a tapped formula:
    Sometimes a formula from a tapped repository may conflict with one in mxcl/master.
    You can still access these formulae by using a special syntax, e.g.
    `homebrew/dupes/vim` or `homebrew/versions/node4`.

  * An arbitrary URL:
    Homebrew can install formulae via URL, e.g.
    `https://raw.github.com/mxcl/homebrew/master/Library/Formula/git.rb`.
    The formula file will be cached for later use.

## ENVIRONMENT

  * GIT:
    When using Git, Homebrew will use `GIT` if set,
    a Homebrew-built Git if installed, or the system-provided binary.

    Set this to force Homebrew to use a particular git binary.

  * EDITOR:
    If set, and `HOMEBREW_EDITOR` is not, use `EDITOR` as the text editor.

  * HOMEBREW\_BUILD\_FROM\_SOURCE:
    If set, instructs Homebrew to compile from source even when a formula
    provides a bottle.

  * HOMEBREW\_CACHE:
    If set, instructs Homebrew to use the give directory as the download cache.
    Otherwise, `~/Library/Caches/Homebrew` is used.

    This can be used to keep downloads out of your home directory, if you have
    it mounted on an SSD or are using FileVault for instance.

  * HOMEBREW\_CURL\_VERBOSE:
    If set, Homebrew will pass `--verbose` when invoking `curl`(1).

  * HOMEBREW\_DEBUG:
    If set, instructs Homebrew to always assume `--debug` when running
    commands.

  * HOMEBREW\_DEBUG\_INSTALL:
    When `brew install -d` or `brew install -i` drops into a shell,
    `HOMEBREW_DEBUG_INSTALL` will be set to the name of the formula being
    brewed.

  * HOMEBREW\_DEBUG\_PREFIX:
    When `brew install -d` or `brew install -i` drops into a shell,
    `HOMEBREW_DEBUG_PREFIX` will be set to the target prefix in the Cellar
    of the formula being brewed.

  * HOMEBREW\_EDITOR:
    If set, Homebrew will use this editor when editing a single formula, or
    several formulae in the same directory.

    *NOTE*: `brew edit` will open all of Homebrew as discontinuous files and
    directories. TextMate can handle this correctly in project mode, but many
    editors will do strange things in this case.

  * HOMEBREW\_KEEP\_INFO:
    If set, Homebrew will not remove files from `share/info`, allowing them
    to be linked from the Cellar. To access these info files, prepend
    `share/info` to your `INFOPATH` environment variable.

    *Example:* `export INFOPATH='/usr/local/share/info:/usr/share/info'`

  * HOMEBREW\_MAKE\_JOBS:
    If set, instructs Homebrew to use the value of `HOMEBREW_MAKE_JOBS` as
    the number of parallel jobs to run when building with `make`(1).

    *Default:* the number of available CPU cores.

  * HOMEBREW\_SVN:
    When exporting from Subversion, Homebrew will use `HOMEBREW_SVN` if set,
    a Homebrew-built Subversion if installed, or the system-provided binary.

    Set this to force Homebrew to use a particular svn binary.

  * HOMEBREW\_TEMP:
    If set, instructs Homebrew to use `HOMEBREW_TEMP` as the temporary directory
    for building packages. This may be needed if your system temp directory and
    Homebrew Prefix are on different volumes, as OS X has trouble moving
    symlinks across volumes when the target does not yet exist.

    This issue typically occurs when using FileVault or custom SSD
    configurations.

  * HOMEBREW\_USE\_CLANG:
    If set, instructs Homebrew to compile using clang.

  * HOMEBREW\_USE\_GCC:
    If set, instructs Homebrew to compile using gcc.

  * HOMEBREW\_USE\_LLVM:
    If set, instructs Homebrew to compile using LLVM.

    *NOTE*: Not all formulae build correctly with LLVM.

  * HOMEBREW\_VERBOSE:
    If set, instructs Homebrew to always assume `--verbose` when running
    commands.

## USING HOMEBREW BEHIND A PROXY

Homebrew uses several commands for downloading files (e.g. curl, git, svn).
Many of these tools can download via a proxy. It's common for these tools
to read proxy parameters from environment variables.

For the majority of cases setting `http_proxy` is enough. You can set this in
your shell profile, or you can use it before a brew command:

    http_proxy=http://<host>:<port> brew install foo

If your proxy requires authentication:

    http_proxy=http://<user>:<password>@<host>:<port> brew install foo

## SEE ALSO

Homebrew Wiki: <http://wiki.github.com/mxcl/homebrew/>

`git`(1), `git-log`(1)

## AUTHORS

Max Howell, a splendid chap.

## BUGS

See Issues on GitHub: <http://github.com/mxcl/homebrew/issues>

