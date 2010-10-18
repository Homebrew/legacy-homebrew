brew(1) -- The missing package manager for OS X
===============================================

## SYNOPSIS

`brew` [--verbose|-v] command [options] [formula] ...  
`brew` [--version|-v]

## DESCRIPTION

Homebrew is the easiest and most flexible way to install the UNIX tools Apple
didn't include with OS X.

## OPTIONS
  * `-v`, `--verbose` command [options] [formula] ...:
    Prints extra, comand-specific debugging information.
    Note that `brew -v` by itself is the same as `brew --version`.

## COMMANDS

  * `-v`, `--version`:
    Prints the version number of brew to standard error and exits.

  * `--prefix` [<formula>]:
    Displays the install path for Homebrew.
    If <formula> is given, display location in the cellar where that package
    is or would be installed.

  * `--cache` [<formula>]:
    Displays the path Homebrew uses to cache downloads.
    If <formula> is given, display the file or folder used to cache that
    specific package.

  * `--config`:
    Shows Homebrew and system configuration useful for debugging. If you file
    a bug report, you will likely be asked for this information if you do not
    provide it.

  * `-S`, `search` <text>|/<text>/:
    Performs a substring search of formula names for <text>. If <text> is
    surrounded with slashes, then it is interpreted as a regular expression.
    If no search term is given, all available formula are displayed.

  * `install [--force] [--debug] [--use-llvm] [--ignore-dependencies] [--HEAD]` <formula>:
    Installs <formula>.

    If `--force` is passed, will install <formula> even if it is already
    installed. This can be used to re-install a formula without removing
    it first.

    If `--debug` is passed and brewing fails, opens a shell inside the
    temporary folder used for compiling.

    If `--use-llvm` is passed, attempt to compile using the LLVM front-end to GCC.
    *NOTE*: Not all formulae will build with LLVM.

    If `--ignore-dependencies` is passed, skip installing any dependencies of
    any kind. If they are not already present, the formula will probably fail
    to install.

    If `--HEAD` is passed, and <formula> defines it, install the HEAD version,
    aka master, trunk, unstable, dev.

    To install a newer version of HEAD use
    `brew rm <foo> && brew install --HEAD <foo>`
    or `brew --force --HEAD <foo>`.

  * `install --interactive [--git]` <formula>:
    Downloads and patches <formula>, and then opens a shell. This allows the
    user to run `./configure --help` and otherwise determine how to turn the
    software package into a Homebrew formula.

    If `--git` is passed, Homebrew will create a Git repository, useful for
    creating patches to the software.

  * `list`:
    Lists all installed formulae.

  * `list` <formula>:
    Lists the installed files for <formula>.

  * `info` <formula>:
    Gives all available information for <formula>.

  * `info --github` <formula>:
    Opens a browser to the GitHub History page for formula <formula>.

  * `info --all`:
    Summarises all installed packages; this is intended to be used by
    higher-level tools.

  * `info` <URL>:
    Prints the name and version that will be detected for <URL>; only http://
    URLs supported for now.

  * `home`:
    Opens a browser to Homebrew's own homepage.

  * `home` <formula>:
    Opens a browser to <formula>'s homepage.

  * `rm`, `remove [--force]` <formula>:
    Uninstalls <formula>.

    If `--force` is passed, and there are multiple versions of <formula>
    installed, deletes all installed versions.

  * `create [--cache]` <URL>:
    Generates a formula for the downloadable file at <URL> and opens it in
    $EDITOR. Homebrew will attempt to automatically derive the formula name
    and version, if it fails, you'll have to make your own template. I suggest
    copying wget's.

    If `--cache` is passed, Homebrew will download the <URL> to the cache and
    add the MD5 to the formula for you.

  * `create --macports`|`--fink` <formula>:
    Opens a browser to the MacPorts or Fink package search page, so you can
    see how they do <formula>.

  * `edit` <formula>:
    Opens the formula in $EDITOR.

  * `edit`:
    Opens all of Homebrew for editing in TextMate.

  * `ln`, `link` <formula>:
    Symlinks all of <formula>'s installed files into the Homebrew prefix. This
    is done automatically when you install formula. It is useful for DIY
    installation, or in cases where you want to swap out different versions of
    the same package that you have installed at the same time.

  * `unlink` <formula>:
    Unsymlinks <formula> from the Homebrew prefix.

  * `prune`:
    Removes dead symlinks from the Homebrew prefix. This is generally not
    needed. However, it can be useful if you are doing DIY installations.

  * `outdated`:
    Shows formula that have an updated version available.

  * `deps [--1]` <formula>:
    Shows <formula>'s dependencies.

    If `--1` is passed, only show dependencies one level down, instead of
    recursing.

  * `uses [--installed]` <formula>:
    Shows the formulas that specify <formula> as a dependency. The list is
    not recursive; only one level of dependencies is resolved.

    If `--installed` is passed, only lists installed formulae.

  * `doctor`:
    Checks your system for potential problems.

  * `cat` <formula>:
    Displays the source to <formula>.

  * `cleanup` [<formula>]:
    For all installed or specific formulae, remove any older versions from the
    cellar.

  * `update`:
    Using Git, fetches the newest version of Homebrew from the GitHub
    repository.

  * `log [git-options]` <formula> ...:
    Shows the git log for the given formulae. Options that `git log`
    recognizes can be passed before the formula list.

  * `fetch [--force] [-v] [--HEAD]` <formula>:
    Downloads the tarball or checks out from VCS for the given <formula>. For
    tarballs, also prints MD5 and SHA1 checksums.

    If `--HEAD` is passed, download the HEAD version of <formula> instead. `-v`
    may also be passed to make the VCS checkout verbose, useful for seeing if
    an existing HEAD cache has been updated.

    If `--force` is passed, remove a previously cached version and re-fetch.

## EXTERNAL COMMANDS

Homebrew allows external commands to be defined by putting a +x file named
`brew-<cmdname>` or `brew-<cmdname>.rb` on the PATH. This will cause Homebrew
to recognize `brew cmdname`.

Some external commands are shipped with Homebrew, and enabled by default.

  * `audit`:
    Checks all formulae for Homebrew coding style violations. This should be
    run before submitting a new formula for inclusion.

  * `options` <formula>:
    Displays install options specific to <formula>.

  * `man`:
    Regenerates this man page from source.

    *NOTE*: Requires [`ronn`][ronn].

  * `missing`:
    Checks all installed formuale for missing dependencies.

  * `server`:
    Starts a local webserver with an app that lets you browse available
    formulae, similar to `gem server`.

    *NOTE*: Requires [`sinatra`][sinatra].

  * `test` <formula>:
    A few formulae provide a test method. `brew test <formula>` runs this
    test method. There is no standard output or return code, but it should
    generally indicate to the user if something is wrong with the installed
    formula.

    Example: `brew install jruby && brew test jruby`

[ronn]: http://rtomayko.github.com/ronn/
        "Ronn"

[sinatra]: http://www.sinatrarb.com/
           "Sinatra"


## ENVIRONMENT

  * HOMEBREW\_DEBUG:
    If set, instructs Homebrew to always assume `--debug` when running
    commands.

  * HOMEBREW\_DEBUG\_INSTALL:
    When `brew install -d` or `brew install -i` drops into a shell,
    `HOMEBREW_DEBUG_INSTALL` will be set to the name of the formula being
    brewed.

  * HOMEBREW\_DEBUG\_PREFIX:
    When `brew install -d` or `brew install -i` drops into a shell,
    `HOMEBREW_DEBUG__PREFIX` will be set to the target prefix in the Cellar
    of the formula being brewed.

  * HOMEBREW\_EDITOR:
    If set, Homebrew will use this editor when editing a single formula, or
    several formulae in the same folder.

    *NOTE*: `brew edit` will open all of Homebrew as discontinuous files and
    folders. TextMate can handle this correctly in project mode, but many
    editors will do strange things in this case.

  * HOMEBREW\_KEEP\_INFO:
    If set, Homebrew will not remove files from share/info, allowing them to
    be linked from the Cellar.

  * HOMEBREW\_SVN:
    When exporting from Subversion, Homebrew will use `HOMEBREW_SVN` if set,
    a Homebrew-built Subversion if installed, or the system-provided binary.

    Set this to force Homebrew to use a particular svn binary.

  * HOMEBREW\_TEMP:
    If set, instructs Homebrew to use `HOMEBREW_TEMP` as the temporary folder
    for building packages. This may be needed if your system temp folder and
    Homebrew Prefix are on different volumes, as OS X has trouble moving
    symlinks across volumes when the target does not yet exist.

    This issue typically occurs when using FileVault (or certain custom SSD
    configurations.)

  * HOMEBREW\_USE\_LLVM:
    If set, instructs Homebrew to use the LLVM front-ends to the GCC
    compilers.

    *NOTE*: Not all formulae will build correctly under LLVM.

  * HOMEBREW\_VERBOSE:
    If set, instructs Homebrew to always assume `--verbose` when running
    commands.

## SEE ALSO

Homebrew Wiki: http://wiki.github.com/mxcl/homebrew/

## AUTHORS

Max Howell, a splendid chap.

## BUGS

See Issues on GitHub: http://github.com/mxcl/homebrew/issues
