# Homebrew and Python
## Overview

This page describes how Python is handled in Homebrew.

Homebrew should work with any [CPython](http://stackoverflow.com/questions/2324208/is-there-any-difference-between-cpython-and-python) and defaults to the OS X system Python.

Homebrew provides formulae to brew a more up-to-date Python 2.7.x (and 3.x).

**Important:** If you choose to install a Python which isn't either of these two (system Python or brewed Python), the Homebrew team can only provide limited support.


## Python 2.x or Python 3.x

Homebrew provides a formula for Python 2.7.x and one for Python 3.x. They don't conflict, so they can both be installed. The executable `python` will always point to the 2.x and `python3` to the 3.x version.

([Wondering which one to choose?](http://wiki.python.org/moin/Python2orPython3))


## Setuptools, Pip, etc.

The Python formulae install [`pip`](http://www.pip-installer.org) and [Setuptools](https://pypi.python.org/pypi/setuptools).

Setuptools can be updated via Pip, without having to re-brew Python:

    pip install --upgrade setuptools

Similarly, Pip can be used to upgrade itself via:

    pip install --upgrade pip

### Note on `pip install --user`

The normal `pip install --user` is disabled for brewed Python. This is because of a bug in distutils, because Homebrew writes a `distutils.cfg` which sets the package `prefix`.

A possible workaround (which puts executable scripts in `~/Library/Python/<X>.<Y>/bin`) is:

    pip install --user --install-option="--prefix=" <package-name>

You can make this "empty prefix" the default by adding a `~/.pydistutils.cfg` file with the following contents:

    [install]
    prefix=

## `site-packages` and the `PYTHONPATH`

The `site-packages` is a directory that contains Python modules (especially bindings installed by other formulae). Homebrew creates it here:

    $(brew --prefix)/lib/pythonX.Y/site-packages

So, for Python 2.7.x, you'll find it at `/usr/local/lib/python2.7/site-packages`.

Python 2.7 also searches for modules in:

  - `/Library/Python/2.7/site-packages`
  - `~/Library/Python/2.7/lib/python/site-packages`

Homebrew's `site-packages` directory is first created if (1) any Homebrew formula with Python bindings are installed, or (2) upon `brew install python`.

### Why here?

The reasoning for this location is to preserve your modules between (minor) upgrades or re-installations of Python. Additionally, Homebrew has a strict policy never to write stuff outside of the `brew --prefix`, so we don't spam your system.

## Homebrew-provided Python bindings

Some formulae provide python bindings. Sometimes a `--with-python` or `--with-python3` option has to be passed to `brew install` in order to build the python bindings. (Check with `brew options <formula>`.)

Homebrew builds bindings against the first `python` (and `python-config`) in your `PATH`. (Check with `which python`).

**Warning!** Python may crash (see [Common Issues](Common-Issues.md)) if you `import <module>` from a brewed Python if you ran `brew install <formula_with_python_bindings>` against the system Python. If you decide to switch to the brewed Python, then reinstall all formulae with python bindings (e.g. `pyside`, `wxwidgets`, `pygtk`, `pygobject`, `opencv`, `vtk` and `boost`).

## Policy for non-brewed Python bindings

These should be installed via `pip install <x>`. To discover, you can use `pip search` or <http://pypi.python.org/pypi>. (**Note:** System Python does not provide `pip`. Simply `easy_install pip` to fix that.)


## Brewed Python modules

For brewed Python, modules installed with `pip` or `python setup.py install` will be installed to `$(brew --prefix)/lib/pythonX.Y/site-packages` directory (explained above). Executable python scripts will be in `$(brew --prefix)/bin`. (To better conform to standard behavior, `brew` no longer puts Python scripts into `share/python/$(brew --prefix)`.)

The system Python may not know which compiler flags to set in order to build bindings for software installed in Homebrew so you may need to:

`CFLAGS=-I$(brew --prefix)/include LDFLAGS=-L$(brew --prefix)/lib pip install <package>`.


## Virtualenv

**WARNING:** When you `brew install` formulae that provide Python bindings, you should **not be in an active virtual environment**.

Activate the virtualenv *after* you've brewed, or brew in a fresh Terminal window.
Homebrew will still install Python modules into Homebrew's `site-packages` and *not* into the virtual environment's site-package.

Virtualenv has a switch to allow "global" (i.e. Homebrew's) `site-packages` to be accessible from within the virtualenv.

## Creating a formulae with nice Python bindings

You can add the following :special dependency to the formula:

    depends_on :python

This assures that Homebrew looks for a suitable Python 2.7 and sets up `PATH` accordingly (as well as a few other things; see below). Omitting this line may lead to error messages like `Python.h not found`.

To allow the user to opt-out (via `--without-python`):

    depends_on :python => :recommended

To allow the user to opt-in (via `--with-python3` for Python3):

    depends_on :python3 => :optional

These options are automatically generated. In the formula you can check via `build.with? 'python'` what the user has decided.

If you need to specify that specific Python modules (rather than just Python itself) are needed:

    depends_on 'numpy' => :python

Or if the import name is different to the module name:

    depends_on "MacFSEvents" => [:python, "fsevents"]

### Python bottles

If the formula is installed from a bottle and `:python` is a required or `:recommended` dependency (not `:optional`) then it will use the Homebrew `python` formula as a dependency. This is because we cannot create a binary package that works against both versions of Python. If you wish to override this behaviour you can install using `--build-from-source` which will link against the system Python (if it's the first in your `PATH`).

### If the software provides a `setup.py`

Usually this line will do the trick:

    system "python", "setup.py", "--prefix=#{prefix}"

The `--prefix=#{prefix}` part is to ensure that Python bindings are installed into the Cellar for that specific formula in:

    $(brew --prefix)/Cellar/<formula>/<version>/lib/python2.7/site-packages

When `brew link` is run (automatically at the end of `brew install`), the Python modules should be linked into `$(brew --prefix)/lib/pythonX.Y/site-packages`, and the scripts should go into `$(brew --prefix)/bin`. This enables brew to `unlink`/`link`/`uninstall` cleanly.

If the `setup.py` is older, it may need two additional arguments to avoid writing an `easy-install.pth` file (which will conflict with the `easy-install.pth` already installed by `pip`/`setuptools`). So, if you get a `brew link` problem mentioning this file, add this to the `setup.py` args:

    "--single-version-externally-managed", "--record=installed.txt"

### If the formula uses `configure`/`make`

Generally, the `./configure` files provided by software Homebrew installs can find `python` or `python-config` (and/or look at the `PYTHON` var). Both are set up by Homebrew during brewing.

Often, a `--with-python` or similar flag can be given to `configure`. Check with `./configure --help`.

If the `configure` and `make` scripts do not want to install into the Cellar, one option is to:

1. Call `./configure --without-python` (or a similar named option)
1. `cd` into the directory containing the Python bindings
1. Call `setup.py` explicitly (as described above)

Sometimes we have to `inreplace` a `Makefile` to use our prefix for the python bindings. (`inreplace` is one of Homebrew's helper methods, which greps and edits text files on-the-fly.)

## Technical details

Formula authors necessarily don't need to read this.

Adding `depends_on :python` triggers the following actions:

- The user `PATH` (the original `PATH`, not the superenv `PATH`) is searched for a suitable `python` executable (`python3` for 3.x).
- The `PYTHONPATH` is set (internally only), so the system Python can find brewed python modules.
