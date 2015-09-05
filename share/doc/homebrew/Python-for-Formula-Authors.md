# Introduction

This document explains how to successfully use Python in a Homebrew formula.

Homebrew draws a distinction between Python **applications** and Python **libraries**. The difference is that users generally do not care that applications are written in Python; it is unusual that a user would expect to be able to `import foo` after installing an application. Examples of applications are `ansible` and `jrnl`.

Python libraries exist to be imported from other Python modules; they are often dependencies of Python applications. They are usually no more than incidentally useful from a Terminal.app command line. Examples of libraries are `py2cairo` and the bindings that are installed by `protobuf --with-python`.

Bindings are a special case of libraries that allow Python code to interact with a library or application implemented in another language.

Homebrew is happy to accept applications that are built in Python, whether the apps are available from PyPI or not. Homebrew generally won't accept libraries that can be installed correctly with `pip install foo`. Libraries that can be pip-installed but have several Homebrew dependencies may be appropriate for the [homebrew-python tap](https://github.com/Homebrew/homebrew-python). Bindings may be installed for packages that provide them, especially if equivalent functionality isn't available through pip.

# Running setup.py

Homebrew provides a helper method, `Language::Python.setup_install_args`, which returns arguments for invoking setup.py. Please use it instead of invoking `setup.py` explicitly. The syntax is:

```ruby
system "python", *Language::Python.setup_install_args(prefix)
```

where `prefix` is the destination prefix (usually `libexec` or `prefix`).

# Python module dependencies

In general, applications should unconditionally bundle all of their dependencies and libraries should install any unsatisfied dependencies; these strategies are discussed in depth in the following sections.

In the rare instance that this proves impractical, you can specify a Python module as an external dependency using the syntax:

```ruby
depends_on "numpy" => :python
```

Or if the import name is different from the module name:

```ruby
depends_on "MacFSEvents" => [:python, "fsevents"]
```

If you submit a formula with this syntax to core, you may be asked to rewrite it as a `Requirement`.

# Applications

`ansible.rb` and `jrnl.rb` are good examples of applications that follow this advice.

## Python declarations

Applications that are compatible with Python 2 **should** use the Apple-provided system Python in /usr/bin on systems that provide Python 2.7. To do this, declare:
```ruby
depends_on :python if MacOS.version <= :snow_leopard
```
No explicit Python dependency is needed on recent OS versions since /usr/bin is always in `PATH` for Homebrew formulæ; on Leopard and older, the python in `PATH` is used if it's at least version 2.7, or else Homebrew's python is installed.

Formulæ for apps that require Python 3 **should** declare an unconditional dependency on `:python3`, which will cause the formula to use the first python3 discovered in `PATH` at install time (or install Homebrew's if there isn't one). These apps **must** work with the current Homebrew python3 formula.

## Installing

Applications should be installed to `libexec`. This prevents the app's Python modules from contaminating the system site-packages, which is important so that pip doesn't try to manage Homebrew-installed packages and because applications' Python dependencies should not be installed to an importable prefix (see below) so `import` won't work anyway.

In your formula's `install` method, first set the `PYTHONPATH` environment variable to your package's libexec site-packages directory with:
```ruby
ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
```
Then, use `system` with `Language::Python.setup_install_args` to invoke `setup.py` like:
```ruby
system "python", *Language::Python.setup_install_args(libexec)
```

This will have placed the scripts your Python package installs in `libexec/"bin"`, which is not symlinked into Homebrew's prefix. We need to make sure these are installed and we also need to make sure that, when they are invoked, `PYTHONPATH` includes the path where we just installed your package. Do this with:

```ruby
bin.install Dir[libexec/"bin/*"]
bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
```
The first line copies all of the executables to bin. The second line writes stubs to bin that set `PYTHONPATH` and moves the original files back to `libexec/"bin"`.

## Dependencies

All Python dependencies of applications that are not packaged by Homebrew (and those dependencies' Python dependencies, recursively) **should** be unconditionally downloaded as `Resource`s and installed into the application keg's `libexec/"vendor"` path. This prevents the state of the system Python packages from being affected by installing an app with Homebrew and guarantees that apps use versions of their dependencies that are known to work together. `libexec/"vendor"` is preferred to `libexec` so that formulæ don't accidentally install executables belonging to their dependencies, which can cause linking conflicts.

Each dependency **should** be explicitly installed; please do not rely on setup.py or pip to perform automatic dependency resolution, for the [reasons described here](Acceptable-Formulae.md#we-dont-like-install-scripts-that-download-things).

You can use [homebrew-pypi-poet](https://pypi.python.org/pypi/homebrew-pypi-poet) to help you write resource stanzas. To use it, set up a virtualenv and install your package and all its dependencies. Then, `pip install homebrew-pypi-poet` into the same virtualenv. `poet -f foo` will draft a complete formula for you, or `poet foo` will just generate the resource stanzas.

Set `PYTHONPATH` to include the `libexec/"vendor"` site-packages path with:
```ruby
ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
```
before staging and installing each resourced dependency with:
```ruby
system "python", *Language::Python.setup_install_args(libexec/"vendor")
```

## Example

Installing a formula with dependencies will look like this:

```ruby
class Foo < Formula
  url ...

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.8.0.tar.gz"
    sha1 "aa3b0659cbc85c6c7a91efc51f2d1007040070cd"
  end

   resource "parsedatetime" do
    url "https://pypi.python.org/packages/source/p/parsedatetime/parsedatetime-1.4.tar.gz"
    sha1 "4b9189d38f819cc8144f30d91779716a696d97f8"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[six parsedatetime].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end
end
```

# Bindings

To add an option to a formula to build Python bindings, use `depends_on :python => :recommended` and install the bindings conditionally on `build.with? "python"` in your `install` method.

Python bindings should be optional because if the formula is bottled, any `:recommended` or mandatory dependencies on `:python` are always resolved by installing the Homebrew `python` formula, which will upset users that prefer to use the system Python. This is because we cannot generally create a binary package that works against both versions of Python.

## Dependencies

Bindings should follow the same advice for Python module dependencies as libraries; see below for more.

## Installing bindings

If the bindings are installed by invoking a `setup.py`, do something like:
```ruby
cd "source/python" do
  system "python", *Language::Python.setup_install_args(prefix)
end
```

If the configure script takes a `--with-python` flag, it usually will not need extra help finding Python.

If the `configure` and `make` scripts do not want to install into the Cellar, sometimes you can:

1. Call `./configure --without-python` (or a similar named option)
1. `cd` into the directory containing the Python bindings
1. Call `setup.py` with `system` and `Language::Python.setup_install_args` (as described above)

Sometimes we have to `inreplace` a `Makefile` to use our prefix for the python bindings. (`inreplace` is one of Homebrew's helper methods, which greps and edits text files on-the-fly.)

# Libraries

## Python declarations

Libraries **should** declare a dependency on `:python` or `:python3` as appropriate, which will respectively cause the formula to use the first python or python3 discovered in `PATH` at install time. If a library supports both Python 2.x and Python 3.x, the `:python` dependency **should** be `:recommended` (i.e. built by default) and the :python3 dependency should be `:optional`. Python 2.x libraries **must** function when they are installed against either the system Python or Homebrew Python.

Formulæ that declare a dependency on `:python` will always be bottled against Homebrew's python, since we cannot in general build binary packages that can be imported from both Pythons. Users can add `--build-from-source` after `brew install` to compile against whichever python is in `PATH`.

## Installing

Libraries may be installed to `libexec` and added to `sys.path` by writing a .pth file (named like "homebrew-foo.pth") to the `prefix` site-packages. This simplifies the ensuing drama if pip is accidentally used to upgrade a Homebrew-installed package and prevents the accumulation of stale .pyc files in Homebrew's site-packages.

Most formulas presently just install to `prefix`.

## Dependencies

The dependencies of libraries must be installed so that they are importable. The principle of minimum surprise suggests that installing a Homebrew library should not alter the other libraries in a user's sys.path. The best way to achieve this is to only install dependencies if they are not already installed. To minimize the potential for linking conflicts, dependencies should be installed to `libexec/"vendor"` and added to `sys.path` by writing a second .pth file (named like "homebrew-foo-dependencies.pth") to the `prefix` site-packages.

The `matplotlib.rb` formula in homebrew-python deploys this strategy.

# Further down the rabbit hole

Additional commentary that explains why Homebrew does some of the things it does.

## setuptools vs. distutils vs. pip

Distutils is a module in the Python standard library that provides developers a basic package management API. Setuptools is a module distributed outside the standard library that extends distutils. It is a convention that Python packages provide a setup.py that calls the `setup()` function from either distutils or setuptools.

Setuptools provides the `easy_install` command, which is an end-user package management tool that fetches and installs packages from PyPI, the Python Package Index. Pip is another, newer end-user package management tool, which is also provided outside the standard library. While pip supplants `easy_install`, pip does not replace the other functionality of the setuptools module.

Distutils and pip use a "flat" installation hierarchy that installs modules as individual files under site-packages while `easy_install` installs zipped eggs to site-packages instead.

Distribute (not to be confused with distutils) is an obsolete fork of setuptools. Distlib is a package maintained outside the standard library which is used by pip for some low-level packaging operations and is not relevant to most setup.py users.

## What is `--single-version-externally-managed`?

`--single-version-externally-managed` ("SVEM") is a setuptools-only [argument to setup.py install](https://pythonhosted.org/setuptools/setuptools.html#install-run-easy-install-or-old-style-installation). The primary effect of SVEM is to use distutils to perform the install instead of using setuptools' `easy_install`.

`easy_install` does a few things that we need to avoid:

* fetches and installs dependencies
* upgrades dependencies in sys.path in place
* writes .pth and site.py files which aren't useful for us and cause link conflicts

setuptools requires that SVEM is used in conjunction with `--record`, which provides a list of files that can later be used to uninstall the package. We don't need or want this because Homebrew can manage uninstallation but since setuptools demands it we comply. The Homebrew convention is to call the record file "installed.txt".

Detecting whether a `setup.py` uses `setup()` from setuptools or distutils is difficult, but we always need to pass this flag to setuptools-based scripts. `pip` faces the same problem that we do and forces `setup()` to use the setuptools version by loading a shim around `setup.py` that imports setuptools before doing anything else. Since setuptools monkey-patches distutils and replaces its `setup` function, this provides a single, consistent interface. We have borrowed this code and use it in `Language::Python.setup_install_args`.


## `--prefix` vs `--root`

setup.py accepts a slightly bewildering array of installation options. The correct switch for Homebrew is `--prefix`, which automatically sets the `--install-foo` family of options using sane POSIX-y values.

`--root` [is used](https://mail.python.org/pipermail/distutils-sig/2010-November/017099.html) when installing into a prefix that will not become part of the final installation location of the files, like when building a .rpm or binary distribution. When using a setup.py-based setuptools, `--root` has the side effect of activating `--single-version-externally-managed`. It is not safe to use `--root` with an empty `--prefix` because the `root` is removed from paths when byte-compiling modules.

It is probably safe to use `--prefix` with `--root=/`, which should work with either setuptools or distutils-based setup.py's but is kinda ugly.

## pip vs. setup.py

[PEP 453](http://legacy.python.org/dev/peps/pep-0453/#recommendations-for-downstream-distributors) makes a recommendation to downstream distributors (us) that sdist tarballs should be installed with pip instead of by invoking setup.py directly. We do not do this because Apple's Python distribution does not include pip, so we can't assume that pip is available. We could do something clever to work around Apple's piplessness but the value proposition is not yet clear.
