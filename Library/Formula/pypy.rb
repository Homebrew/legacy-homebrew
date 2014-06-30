require 'formula'

class Pypy < Formula
  homepage 'http://pypy.org/'
  url 'https://bitbucket.org/pypy/pypy/downloads/pypy-2.3.1-osx64.tar.bz2'
  version '2.3.1'
  sha1 '4d9cdf801e4c8fb432b17be0edf76eb3d9360f40'

  depends_on :arch => :x86_64

  resource 'setuptools' do
    url 'https://pypi.python.org/packages/source/s/setuptools/setuptools-5.2.tar.gz'
    sha1 '749f1ea153426866d6117d00256cf37c90b1b4f5'
  end

  resource 'pip' do
    url 'https://pypi.python.org/packages/source/p/pip/pip-1.5.6.tar.gz'
    sha1 'e6cd9e6f2fd8d28c9976313632ef8aa8ac31249e'
  end

  def install
    # Having PYTHONPATH set can cause the build to fail if another
    # Python is present, e.g. a Homebrew-provided Python 2.x
    # See https://github.com/Homebrew/homebrew/issues/24364
    ENV['PYTHONPATH'] = ''

    rmtree 'site-packages'

    # The PyPy binary install instructions suggest installing somewhere
    # (like /opt) and symlinking in binaries as needed. Specifically,
    # we want to avoid putting PyPy's Python.h somewhere that configure
    # scripts will find it.
    libexec.install Dir['*']
    bin.install_symlink libexec/"bin/pypy"

    # Post-install, fix up the site-packages and install-scripts folders
    # so that user-installed Python software survives minor updates, such
    # as going from 1.7.0 to 1.7.1.

    # Create a site-packages in the prefix.
    prefix_site_packages.mkpath

    # Symlink the prefix site-packages into the cellar.
    libexec.install_symlink prefix_site_packages

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

    # Symlinks to easy_install_pypy and pip_pypy
    bin.install_symlink scripts_folder/'easy_install' => "easy_install_pypy"
    bin.install_symlink scripts_folder/'pip' => "pip_pypy"
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

    See: https://github.com/Homebrew/homebrew/wiki/Homebrew-and-Python
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
