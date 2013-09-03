brew(1) -- The missing package manager for OS X
===============================================

## SYNOPSIS

`brew` --version  
`brew` command [--verbose|-v] [options] [formula] ...

## DESCRIPTION

Homebrew is the easiest and most flexible way to install the UNIX tools Apple
didn't include with OS X.

## ESSENTIAL COMMANDS

For the full command list, see the COMMANDS section.

With `--verbose` or `-v`, many commands print extra debugging information.
Note that these flags should only appear after a command.

  * `install` <formula>:
    Install <formula>.

  * `remove` <formula>:
    Uninstall <formula>.

  * `update`:
    Fetch the newest version of Homebrew from GitHub using `git`(1).

  * `list`:
    List all installed formulae.

  * `search` <text>|/<text>/:
    Perform a substring search of formula names for <text>. If <text> is
    surrounded with slashes, then it is interpreted as a regular expression.
    The search for <text> is extended online to some popular taps.
    If no search term is given, all locally available formulae are listed.

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

  * `create <URL> [--autotools|--cmake] [--no-fetch] [--set-name <name>] [--set-version <version>]`:
    Generate a formula for the downloadable file at <URL> and open it in the editor.
    Homebrew will attempt to automatically derive the formula name
    and version, but if it fails, you'll have to make your own template. The wget
    formula serves as a simple example. For a complete cheat-sheet, have a look at

    `$(brew --prefix)/Library/Contributions/example-formula.rb`

    If `--autotools` is passed, create a basic template for an Autotools-style build.
    If `--cmake` is passed, create a basic template for a CMake-style build.

    If `--no-fetch` is passed, Homebrew will not download <URL> to the cache and
    will thus not add the SHA-1 to the formula for you.

    The options `--set-name` and `--set-version` each take an argument and allow
    you to explicitly set the name and version of the package you are creating.

  * `deps [--1] [-n] [--tree] [--all] [--installed]` <formula>:
    Show <formula>'s dependencies.

    If `--1` is passed, only show dependencies one level down, instead of
    recursing.

    If `-n` is passed, show dependencies in topological order.

    If `--tree` is passed, show dependencies as a tree.

    If `--all` is passed, show dependencies for all formulae.

    If `--installed` is passed, show dependencies for all installed formulae.

  * `diy [--set-name <name>] [--set-version <version>]`:
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
    Open <formula> in the editor.

  * `fetch [--force] [-v] [--HEAD] [--deps] [--build-from-source]` <formulae>:
    Download the source packages for the given <formulae>.
    For tarballs, also print SHA1 and SHA-256 checksums.

    If `--HEAD` is passed, download the HEAD versions of <formulae> instead. `-v`
    may also be passed to make the VCS checkout verbose, useful for seeing if
    an existing HEAD cache has been updated.

    If `--force` is passed, remove a previously cached version and re-fetch.

    If `--deps` is passed, also download dependencies for any listed <formulae>.

    If `--build-from-source` is passed, download the source rather than a
    bottle.

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

  * `install [--debug] [--env=<std|super>] [--ignore-dependencies] [--fresh] [--cc=<compiler>] [--use-clang|--use-gcc|--use-llvm] [--build-from-source] [--devel|--HEAD]` <formula>:
    Install <formula>.

    <formula> is usually the name of the formula to install, but it can be specified
    several different ways. See [SPECIFYING FORMULAE][].

    If `--debug` is passed and brewing fails, open an interactive debugging
    session with access to IRB, ruby-debug, or a shell inside the temporary
    build directory.

    If `--env=std` is passed, use the standard build environment instead of superenv.

    If `--env=super` is passed, use superenv even if the formula specifies the
    standard build environment.

    If `--ignore-dependencies` is passed, skip installing any dependencies of
    any kind. If they are not already present, the formula will probably fail
    to install.

    If `--fresh` is passed, the installation process will not re-use any
    options from previous installs.

    If `--cc=<compiler>` is passed, attempt to compile using the specified
    compiler. The specified argument should be the name of the compiler's
    executable, for instance `gcc-4.2` for Apple's GCC 4.2.
    This option is the only way to select a non-Apple compiler; for instance,
    to build using a Homebrew-provided GCC 4.8, use `--cc=gcc-4.8`

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
    `brew rm <foo> && brew install --HEAD <foo>`.

  * `install --interactive [--git]` <formula>:
    Download and patch <formula>, then open a shell. This allows the user to
    run `./configure --help` and otherwise determine how to turn the software
    package into a Homebrew formula.

    If `--git` is passed, Homebrew will create a Git repository, useful for
    creating patches to the software.

  * `ln`, `link [--overwrite] [--dry-run] [--force]` <formula>:
    Symlink all of <formula>'s installed files into the Homebrew prefix. This
    is done automatically when you install formula, but can be useful for DIY
    installations.

    If `--overwrite` is passed, Homebrew will delete files which already exist in
    the prefix while linking.

    If `--dry-run` or `-n` is passed, Homebrew will list all files which would
    be linked or which would be deleted by `brew link --overwrite`, but will not
    actually link or delete any files.

    If `--force` is passed, Homebrew will allow keg-only formulae to be linked.

  * `ls, list [--unbrewed] [--versions] [--pinned]` [<formulae>]:
    Without any arguments, list all installed formulae.

    If <formulae> are given, list the installed files for <formulae>.
    Combined with `--verbose`, recursively list the contents of all subdirectories
    in each <formula>'s keg.

    If `--unbrewed` is passed, list all files in the Homebrew prefix not installed
    by Homebrew.

    If `--versions` is passed, show the version number for installed formulae,
    or only the specified formulae if <formulae> are given.

    If `--pinned` is passed, show the versions of pinned formulae, or only the
    specified (pinned) formulae if <formulae> are given.
    See also `pin`, `unpin`.

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

  * `pin` <formulae>:
    Pin the specified <formulae>, preventing them from being upgraded when
    issuing the `brew upgrade` command without arguments. See also `unpin`.

  * `prune`:
    Remove dead symlinks from the Homebrew prefix. This is generally not
    needed, but can be useful when doing DIY installations.

  * `rm`, `remove`, `uninstall [--force]` <formula>:
    Uninstall <formula>.

    If `--force` is passed, and there are multiple versions of <formula>
    installed, delete all installed versions.

  * `search`, `-S`:
    Display all locally available formulae for brewing (including tapped ones).
    No online search is performed if called without arguments.

  * `search`, `-S` <tap>:
    Display all formulae in a <tap>, even if not yet tapped.
    <tap> is of the form <user>/<repo>, e.g. `brew search homebrew/dupes`.

  * `search`, `-S` [<tap>] <text>|/<text>/:
    Perform a substring search of formula names for <text>. If <text> is
    surrounded with slashes, then it is interpreted as a regular expression.
    The search for <text> is extended online to some popular taps.
    If a <tap> is specified, the search is restricted to it.

  * `search --debian`|`--fedora`|`--fink`|`--macports`|`--opensuse`|`--ubuntu` <text>:
    Search for <text> in the given package manager's list.

  * `sh [--env=std]`:
    Instantiate a Homebrew build environment. Uses our years-battle-hardened
    Homebrew build logic to help your `./configure && make && make install`
    or even your `gem install` succeeed. Especially handy if you run Homebrew
    in a Xcode-only configuration since it adds tools like make to your PATH
    which otherwise build-systems would not find.

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
    Remove symlinks for <formula> from the Homebrew prefix. This can be useful
    for temporarily disabling a formula:
    `brew unlink foo && commands && brew link foo`.

  * `unpin` <formulae>:
    Unpin <formulae>, allowing them to be upgraded by `brew upgrade`. See also
    `pin`.

  * `untap` <tap>:
    Remove a tapped repository.

  * `update [--rebase]`:
    Fetch the newest version of Homebrew and all formulae from GitHub using
     `git`(1).

    If `--rebase` is specified then `git pull --rebase` is used.

  * `upgrade [install-options]` [<formulae>]:
    Upgrade outdated, unpinned brews.

    Options for the `install` command are also valid here.

    If <formulae> are given, upgrade only the specified brews (but do so even
    if they are pinned; see `pin`, `unpin`).

  * `uses [--installed] [--recursive]` <formula>:
    Show the formulae that specify <formula> as a dependency.

    Use `--recursive` to resolve more than one level of dependencies.

    If `--installed` is passed, only list installed formulae.

  * `versions [--compact]` <formulae>:
    List previous versions of <formulae>, along with a command to checkout
    each version.

    If `--compact` is passed, show all options on a single line separated by
    spaces.

  * `--cache`:
    Display Homebrew's download cache. See also `HOMEBREW_CACHE`.

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

  * `--env`:
    Show a summary of the Homebrew build environment.

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

    $ ls `brew --repository`/Library/Contributions/cmd

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

  * BROWSER:
    If set, and `HOMEBREW_BROWSER` is not, use `BROWSER` as the web browser
    when opening project homepages.

  * EDITOR:
    If set, and `HOMEBREW_EDITOR` and `VISUAL` are not, use `EDITOR` as the text editor.

  * GIT:
    When using Git, Homebrew will use `GIT` if set,
    a Homebrew-built Git if installed, or the system-provided binary.

    Set this to force Homebrew to use a particular git binary.

  * HOMEBREW_BROWSER:
    If set, uses this setting as the browser when opening project homepages,
    instead of the OS default browser.

  * HOMEBREW\_BUILD\_FROM\_SOURCE:
    If set, instructs Homebrew to compile from source even when a formula
    provides a bottle.

  * HOMEBREW\_CACHE:
    If set, instructs Homebrew to use the given directory as the download cache.

    *Default:* `~/Library/Caches/Homebrew` if it exists; otherwise,
    `/Library/Caches/Homebrew`.

  * HOMEBREW\_CURL\_VERBOSE:
    If set, Homebrew will pass `--verbose` when invoking `curl`(1).

  * HOMEBREW\_DEBUG:
    If set, any commands that can emit debugging information will do so.

  * HOMEBREW\_DEBUG\_INSTALL:
    When `brew install -d` or `brew install -i` drops into a shell,
    `HOMEBREW_DEBUG_INSTALL` will be set to the name of the formula being
    brewed.

  * HOMEBREW\_DEBUG\_PREFIX:
    When `brew install -d` or `brew install -i` drops into a shell,
    `HOMEBREW_DEBUG_PREFIX` will be set to the target prefix in the Cellar
    of the formula being brewed.

  * HOMEBREW\_DEVELOPER:
    If set, Homebrew will print warnings that are only relevant to Homebrew
    developers (active or budding).

  * HOMEBREW\_EDITOR:
    If set, Homebrew will use this editor when editing a single formula, or
    several formulae in the same directory.

    *NOTE*: `brew edit` will open all of Homebrew as discontinuous files and
    directories. TextMate can handle this correctly in project mode, but many
    editors will do strange things in this case.

  * HOMEBREW\_GITHUB\_API\_TOKEN:
    A personal GitHub API Access token, which you can create at
    <https://github.com/settings/applications>. If set, GitHub will allow you a
    greater number of API requests. See
    <http://developer.github.com/v3/#rate-limiting> for more information.
    Homebrew uses the GitHub API for features such as `brew search`.

  * HOMEBREW\_KEEP\_INFO:
    If set, Homebrew will not remove files from `share/info`, allowing them
    to be linked from the Cellar. To access these info files, prepend
    `share/info` to your `INFOPATH` environment variable.

    *Example:* `export INFOPATH='/usr/local/share/info:/usr/share/info'`

  * HOMEBREW\_MAKE\_JOBS:
    If set, instructs Homebrew to use the value of `HOMEBREW_MAKE_JOBS` as
    the number of parallel jobs to run when building with `make`(1).

    *Default:* the number of available CPU cores.

  * HOMEBREW\_NO\_EMOJI:
    If set, Homebrew will not print the beer emoji on a successful build.

    *Note:* Homebrew will only try to print emoji on Lion or newer.

  * HOMEBREW\_SOURCEFORGE\_MIRROR:
    If set, Homebrew will use the value of `HOMEBREW_SOURCEFORGE_MIRROR` to
    select a SourceForge mirror for downloading bottles.

    *Example:* `export HOMEBREW_SOURCEFORGE_MIRROR='heanet'`

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

  * HOMEBREW\_VERBOSE:
    If set, Homebrew always assumes `--verbose` when running commands.

  * VISUAL:
    If set, and `HOMEBREW_EDITOR` is not, use `VISUAL` as the text editor.

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

