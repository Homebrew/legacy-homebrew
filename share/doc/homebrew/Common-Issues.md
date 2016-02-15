# Common Issues
This is a list of commonly encountered problems, known issues, and their solutions.

### `brew` complains about absence of "Command Line Tools"
You need to have the Xcode Command Line Utilities installed (and updated): run `xcode-select --install` in the terminal.
(In OS X prior to 10.9, the "Command Line Tools" package can alternatively be installed from within Xcode. `⌘,` will get you to preferences. Visit the "Downloads" tab and hit the install button next to "Command Line Tools".)

### Ruby `bad interpreter: /usr/bin/ruby^M: no such file or directory`
You cloned with git, and your git configuration is set to use Windows line endings. See this page: https://help.github.com/articles/dealing-with-line-endings


### Ruby `bad interpreter: /usr/bin/ruby`
You don't have a `/usr/bin/ruby` or it is not executable. It's not recommended to let this persist, you'd be surprised how many .apps, tools and scripts expect your OS X provided files and directories to be *unmodified* since OS X was installed.

### `brew update` complains about untracked working tree files
After running `brew update`, you receive a git error warning about untracked files or local changes that would be overwritten by a checkout or merge, followed by a list of files inside your Homebrew installation.

This is caused by an old bug in in the `update` code that has long since been fixed. However, the nature of the bug requires that you do the following:

```bash
cd $(brew --repository)
git reset --hard FETCH_HEAD
```
If `brew doctor` still complains about uncommitted modifications, also run this command:
```bash
cd $(brew --repository)/Library
git clean -fd
```

### invalid multibyte escape: /^\037\213/

You see an error similar to:

```
Error: /usr/local/Library/Homebrew/download_strategy.rb:84: invalid multibyte escape: /^\037\213/
invalid multibyte escape: /^\037\235/
```

In the past, Homebrew assumed that `/usr/bin/ruby` was Ruby 1.8. On OS X 10.9, it is now Ruby 2.0. There are various incompatibilities between the two versions, so if you upgrade to OS X 10.9 while using a sufficiently old version of Homebrew, you will encounter errors.

The incompatibilities have been addressed in more recent versions of Homebrew, and it does not make assumptions about `/usr/bin/ruby`, instead it uses the executable inside OS X's Ruby 1.8 framework.

To recover from this situation, do the following:

```
cd /usr/local # your Homebrew prefix
git fetch origin
git reset --hard FETCH_HEAD
brew update
```

### `launchctl` refuses to load launchd plist files
When trying to load a plist file into launchctl, you receive an error that resembles

```
Bug: launchctl.c:2325 (23930):13: (dbfd = open(g_job_overrides_db_path, [...]
launch_msg(): Socket is not connected
```
or

```bash
Could not open job overrides database at: /private/var/db/launchd.db/com.apple.launchd/overrides.plist: 13: Permission denied
launch_msg(): Socket is not connected
```

These are likely due to one of four issues:

1. You are using iTerm. The solution is to use Terminal.app when interacting with `launchctl`.
2. You are using a terminal multiplexer such as `tmux` or `screen`. You should interact with `launchctl` from a separate Terminal.app shell.
3. You are attempting to run `launchctl` while logged in remotely.  You should enable screen sharing on the remote machine and issue the command using Terminal.app running on that machine.
4. You are su'ed as a different user.

### `brew upgrade` errors out
When running `brew upgrade`, you see something like this:
```text
$ brew upgrade
Error: undefined method `include?' for nil:NilClass
Please report this bug:
    https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Troubleshooting.md
/usr/local/Library/Homebrew/formula.rb:393:in `canonical_name'
/usr/local/Library/Homebrew/formula.rb:425:in `factory'
/usr/local/Library/Contributions/examples/brew-upgrade.rb:7
/usr/local/Library/Contributions/examples/brew-upgrade.rb:7:in `map'
/usr/local/Library/Contributions/examples/brew-upgrade.rb:7
/usr/local/bin/brew:46:in `require'
/usr/local/bin/brew:46:in `require?'
/usr/local/bin/brew:79
```

This happens because an old version of the upgrade command is hanging around for some reason. The fix:

```
$ cd $(brew --repository)/Library/Contributions/examples
$ git clean -n # if this doesn't list anything that you want to keep, then
$ git clean -f # this will remove untracked files
```

### Python: `Segmentation fault: 11` on `import <some_python_module>`

A `Segmentation fault: 11` is in many cases due to a different Python
executable used for building the software vs. the python you use to import the
module.  This can even happen when both python executables are the same version
(e.g. 2.7.2). The explanation is that Python packages with C extensions (those
that have `.so` files) are compiled against a certain python binary/library that
may have been built with a different arch (e.g. Apple's python is still not a
pure 64-bit build). Other things can go wrong, too. Welcome to the dirty
underworld of C.

To solve this, you should remove the problematic formula with those python
bindings and all of its dependencies.

  - `brew rm $(brew deps --installed <problematic_formula>)`
  - `brew rm <problematic_formula>`
  - Also check the `$(brew --prefix)/lib/python2.7/site-packages` directory and
    delete all remains of the corresponding python modules if they were not
    cleanly removed by the previous steps.
  - Check that `which python` points to the python you want. Perhaps now is the
    time to `brew install python`.
  - Then reinstall `brew install <problematic_formula>`
  - Now start `python` and try to `import` the module installed by the
    \<problematic_formula\>

You can basically use any Python (2.x) for the bindings homebrew provides, but
you can't mix.  Homebrew formulae use a brewed Python if available or, if not
so, they use whatever `python` is in your `PATH`.

### Python: `Fatal Python error: PyThreadState_Get: no current thread`

```
Fatal Python error: PyThreadState_Get: no current thread
Abort trap: 6
```

This happens for `boost-python`, `pygtk`, `pygobject`, and related modules,
for the same reason as described above. To solve this, follow the steps above.

If `boost` is your problem, note that Boost.Python is now provided by the
`boost-python` formula. Removing any existing `boost` and `boost-python`,
running `brew update`, and installing them anew should fix things.

### Python: easy-install.pth cannot be linked
```
Warning: Could not link <formulaname>. Unlinking...
Error: The `brew link` step did not complete successfully
The formula built, but is not symlinked into /usr/local
You can try again using `brew link <formulaname>'

Possible conflicting files are:
/usr/local/lib/python2.7/site-packages/site.py
/usr/local/lib/python2.7/site-packages/easy-install.pth
==> Could not symlink file: /homebrew/Cellar/<formulaname>/<version>/lib/python2.7/site-packages/site.py
Target /usr/local/lib/python2.7/site-packages/site.py already exists. You may need to delete it.
To force the link and overwrite all other conflicting files, do:
  brew link --overwrite formula_name

To list all files that would be deleted:
  brew link --overwrite --dry-run formula_name
```

Don't follow the advice here but fix by using
`Language::Python.setup_install_args` in the formula as described in
[Python for Formula Authors](Python-for-Formula-Authors.md).

### Upgrading OS X

Upgrading OS X can cause errors like the following:

- `dyld: Library not loaded: /usr/local/opt/icu4c/lib/libicui18n.54.dylib`
- `configure: error: Cannot find libz`

Following an OS X upgrade it may be necessary to reinstall the Xcode Command Line Tools and `brew upgrade` all installed formula:

```bash
xcode-select --install
brew upgrade
```
