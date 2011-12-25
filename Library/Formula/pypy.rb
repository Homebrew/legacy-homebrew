require 'formula'

# Python 2.7.x is available as a separate formula:
# $ brew install python
# Python 3 is also available:
# $ brew install python3

class Distribute < Formula
  url 'http://pypi.python.org/packages/source/d/distribute/distribute-0.6.24.tar.gz'
  md5 '17722b22141aba8235787f79800cc452'
end

class Pypy < Formula
  url 'https://bitbucket.org/pypy/pypy/downloads/pypy-1.7-osx64.tar.bz2'
  md5 'ff979054fc8e17b4973ffebb9844b159'
  version '1.7'
  homepage 'http://pypy.org/'

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
    (prefix+"lib-python/modified-2.7/distutils/distutils.cfg").write <<-EOF.undent
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
      ln_s "#{scripts_folder}/easy_install", "#{scripts_folder}/easy_install_pypy"
    end
  end

  def caveats
    return <<-EOS.undent
    A "distutils.cfg" has been written to:
      #{lib}/pypy/distutils
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
end
