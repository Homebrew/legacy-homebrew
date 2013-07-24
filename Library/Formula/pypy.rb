require 'formula'

class Setuptools < Formula
  url 'https://pypi.python.org/packages/source/s/setuptools/setuptools-0.9.5.tar.gz'
  sha1 'a6ea38fb68f32abf7c1b1fe9a9c56c413f096c3a'
end

class Pypy < Formula
  homepage 'http://pypy.org/'
  url 'https://bitbucket.org/pypy/pypy/downloads/pypy-2.0.2-osx64.tar.bz2'
  version '2.0.2'
  sha1 'a53de7bc88b9caa635d9d679c6e63813881ea7e9'

  depends_on :arch => :x86_64

  def install
    rmtree 'site-packages'

    prefix.install Dir['*']

    # Post-install, fix up the site-packages and install-scripts folders
    # so that user-installed Python software survives minor updates, such
    # as going from 1.7.0 to 1.7.1.

    # Create a site-packages in the prefix.
    prefix_site_packages.mkpath

    # Symlink the prefix site-packages into the cellar.
    ln_s prefix_site_packages, prefix+'site-packages'

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
    Setuptools.new.brew do
      system "#{bin}/pypy", "setup.py", "install"
    end

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
    prefix+"lib-python/2.7/distutils"
  end
end
