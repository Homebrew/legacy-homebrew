require 'formula'

class Pypy3 < Formula
  homepage 'http://pypy.org/'
  url 'https://bitbucket.org/pypy/pypy/downloads/pypy3-2.1-beta1-osx64.tar.bz2'
  version '2.1b1'
  sha1 '4455121f59214332b77d7c93e1d1849d0507d4cb'

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

    # PyPy3 2.1b1 does not include its site-packages in sys.path. Without
    # knowing why this isn't working, it's hard to fix it cleanly, but we
    # can work around it by adding another symlink in one of the places
    # it _does_ check.
    (libexec+'lib').mkpath
    (libexec+'lib/python3.2').mkpath
    ln_s prefix_site_packages, libexec+'lib/python3.2/site-packages'

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

    # Symlink to easy_install_pypy3.
    unless (scripts_folder+'easy_install_pypy3').exist?
      ln_s "#{scripts_folder}/easy_install", "#{scripts_folder}/easy_install_pypy3"
    end

    # Symlink to pip_pypy3.
    unless (scripts_folder+'pip_pypy3').exist?
      ln_s "#{scripts_folder}/pip", "#{scripts_folder}/pip_pypy3"
    end
  end

  def caveats; <<-EOS.undent
    A "distutils.cfg" has been written to:
      #{distutils}
    specifing the install-scripts folder as:
      #{scripts_folder}

    If you install Python packages via "pypy3 setup.py install", easy_install_pypy3,
    pip_pypy3, any provided scripts will go into the install-scripts folder above,
    so you may want to add it to your PATH *after* the `$(brew --prefix)/bin`
    so you don't overwrite tools from CPython.

    Setuptools has been installed, so easy_install is available.
    To update setuptools itself outside of Homebrew:
        #{scripts_folder}/easy_install_pypy3 pip
        #{scripts_folder}/pip_pypy3 install --upgrade setuptools

    See: https://github.com/mxcl/homebrew/wiki/Homebrew-and-Python
    EOS
  end

  # The HOMEBREW_PREFIX location of site-packages
  def prefix_site_packages
    HOMEBREW_PREFIX+"lib/pypy3/site-packages"
  end

  # Where setuptools will install executable scripts
  def scripts_folder
    HOMEBREW_PREFIX+"share/pypy3"
  end

  # The Cellar location of distutils
  def distutils
    libexec+"lib-python/3/distutils"
  end
end
