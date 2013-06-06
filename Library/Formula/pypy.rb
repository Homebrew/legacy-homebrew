require 'formula'

class Distribute < Formula
  url 'http://pypi.python.org/packages/source/d/distribute/distribute-0.6.40.tar.gz'
  sha1 '46654be10177014bbb502a4c516627173de67d15'
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

    # Install distribute. The user can then do:
    # $ easy_install pip
    # $ pip install --upgrade distribute
    # to get newer versions of distribute outside of Homebrew.
    Distribute.new.brew do
      system "#{bin}/pypy", "setup.py", "install"

      # Symlink to easy_install_pypy.
      unless (scripts_folder+'easy_install_pypy').exist?
        ln_s "#{scripts_folder}/easy_install", "#{scripts_folder}/easy_install_pypy"
      end
      # Symlink to pip_pypy.
      unless (scripts_folder+'pip_pypy').exist?
        ln_s "#{scripts_folder}/pip", "#{scripts_folder}/pip_pypy"
      end
    end
  end

  def caveats; <<-EOS.undent
    A "distutils.cfg" has been written to:
      #{distutils}
    specifing the install-scripts folder as:
      #{scripts_folder}

    If you install Python packages via "pypy setup.py install", easy_install, pip,
    any provided scripts will go into the install-scripts folder above, so you may
    want to add it to your PATH.

    Distribute has been installed, so easy_install is available.
    To update distribute itself outside of Homebrew:
        #{scripts_folder}/easy_install pip
        #{scripts_folder}/pip install --upgrade distribute

    See: https://github.com/mxcl/homebrew/wiki/Homebrew-and-Python
    EOS
  end

  # The HOMEBREW_PREFIX location of site-packages
  def prefix_site_packages
    HOMEBREW_PREFIX+"lib/pypy/site-packages"
  end

  # Where distribute will install executable scripts
  def scripts_folder
    HOMEBREW_PREFIX+"share/pypy"
  end

  # The Cellar location of distutils
  def distutils
    prefix+"lib-python/2.7/distutils"
  end
end
