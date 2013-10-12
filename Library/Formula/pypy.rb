require 'formula'

class Pypy < Formula
  homepage 'http://pypy.org/'
  url 'https://bitbucket.org/pypy/pypy/downloads/pypy-2.1-osx64.tar.bz2'
  version '2.1.0'
  sha1 '6cdaa1dc0a47d9eb6d816f7d394ca46f290a1ed5'

  depends_on :arch => :x86_64

  resource 'setuptools' do
    url 'https://pypi.python.org/packages/source/s/setuptools/setuptools-1.1.6.tar.gz'
    sha1 '4a8863e8196704759a5800afbcf33a94b802ac88'
  end

  resource 'pip' do
    url 'https://pypi.python.org/packages/source/p/pip/pip-1.4.1.tar.gz'
    sha1 '9766254c7909af6d04739b4a7732cc29e9a48cb0'
  end

  def install
    rmtree 'site-packages'

    # The PyPy binary install instructions suggest installing somewhere
    # (like /opt) and symlinking in binaries as needed. Specifically,
    # we want to avoid putting PyPy's Python.h somewhere that configure
    # scripts will find it.
    libexec.install Dir['*']

    # Post-install, fix up the site-packages and install-scripts folders
    # so that user-installed Python software survives minor updates, such
    # as going from 1.7.0 to 1.7.1.

    # Create a site-packages in the prefix.
    prefix_site_packages.mkpath

    # Symlink the prefix site-packages into the cellar.
    ln_s prefix_site_packages, libexec+'site-packages'

    # Tell distutils-based installers where to put scripts
    scripts_folder.mkpath
    (distutils+"distutils.cfg").write <<-EOF.undent
      [install]
      install-scripts=#{scripts_folder}
    EOF

    # Install setuptools. The user can then do:
    # $ easy_install pip
    # $ pip install --upgrade setuptools
    # to get newer versions of setuptools outside of Homebrew.
    resource('setuptools').stage { system "#{libexec}/bin/pypy", "setup.py", "install" }
    resource('pip').stage { system "#{libexec}/bin/pypy", "setup.py", "install" }

    # Symlink to easy_install_pypy.
    unless (scripts_folder+'easy_install_pypy').exist?
      ln_s "#{scripts_folder}/easy_install", "#{scripts_folder}/easy_install_pypy"
    end

    # Symlink to pip_pypy.
    unless (scripts_folder+'pip_pypy').exist?
      ln_s "#{scripts_folder}/pip", "#{scripts_folder}/pip_pypy"
    end
  end

  def caveats; <<-EOS.undent
    A "distutils.cfg" has been written to:
      #{distutils}
    specifing the install-scripts folder as:
      #{scripts_folder}

    If you install Python packages via "pypy setup.py install", easy_install_pypy,
    pip_pypy, any provided scripts will go into the install-scripts folder above,
    so you may want to add it to your PATH *after* the `$(brew --prefix)/bin`
    so you don't overwrite tools from CPython.

    Setuptools has been installed, so easy_install is available.
    To update setuptools itself outside of Homebrew:
        #{scripts_folder}/easy_install pip
        #{scripts_folder}/pip install --upgrade setuptools

    See: https://github.com/mxcl/homebrew/wiki/Homebrew-and-Python
    EOS
  end

  # The HOMEBREW_PREFIX location of site-packages
  def prefix_site_packages
    HOMEBREW_PREFIX+"lib/pypy/site-packages"
  end

  # Where setuptools will install executable scripts
  def scripts_folder
    HOMEBREW_PREFIX+"share/pypy"
  end

  # The Cellar location of distutils
  def distutils
    libexec+"lib-python/2.7/distutils"
  end
end
