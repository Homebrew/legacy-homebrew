# Homebrew and Python
## Overview

This page describes how Python is handled in Homebrew for users. See [Python for Formula Authors](Python-for-Formula-Authors.md) for advice on writing formulae to install packages written in Python.

Homebrew should work with any [CPython](https://stackoverflow.com/questions/2324208/is-there-any-difference-between-cpython-and-python) and defaults to the OS X system Python.

Homebrew provides formulae to brew a more up-to-date Python 2.7.x (and 3.x).

**Important:** If you choose to install a Python which isn't either of these two (system Python or brewed Python), the Homebrew team can only provide limited support.


## Python 2.x or Python 3.x

Homebrew provides a formula for Python 2.7.x and one for Python 3.x. They don't conflict, so they can both be installed. The executable `python` will always point to the 2.x and `python3` to the 3.x version.

([Wondering which one to choose?](https://wiki.python.org/moin/Python2orPython3))


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

**Warning!** Python may crash (see [Common Issues](Common-Issues.md)) if you `import <module>` from a brewed Python if you ran `brew install <formula_with_python_bindings>` against the system Python. If you decide to switch to the brewed Python, then reinstall all formulae with python bindings (e.g. `pyside`, `wxwidgets`, `pygtk`, `pygobject`, `opencv`, `vtk` and `boost-python`).

## Policy for non-brewed Python bindings

These should be installed via `pip install <x>`. To discover, you can use `pip search` or <https://pypi.python.org/pypi>. (**Note:** System Python does not provide `pip`. Follow the instructions at https://pip.readthedocs.org/en/stable/installing/#install-pip to install it for your system Python if you would like it.)


## Brewed Python modules

For brewed Python, modules installed with `pip` or `python setup.py install` will be installed to `$(brew --prefix)/lib/pythonX.Y/site-packages` directory (explained above). Executable python scripts will be in `$(brew --prefix)/bin`.

The system Python may not know which compiler flags to set in order to build bindings for software installed in Homebrew so you may need to:

`CFLAGS=-I$(brew --prefix)/include LDFLAGS=-L$(brew --prefix)/lib pip install <package>`.


## Virtualenv

**WARNING:** When you `brew install` formulae that provide Python bindings, you should **not be in an active virtual environment**.

Activate the virtualenv *after* you've brewed, or brew in a fresh Terminal window.
Homebrew will still install Python modules into Homebrew's `site-packages` and *not* into the virtual environment's site-package.

Virtualenv has a switch to allow "global" (i.e. Homebrew's) `site-packages` to be accessible from within the virtualenv.

## Why is Homebrew's Python being installed as a dependency?

Formulae that depend on the special :python target are bottled against the Homebrew Python and require it to be installed. You can avoid installing Homebrew's Python by building these formulae with `--build-from-source`.
