require 'formula'

class Distribute < Formula
  url 'http://pypi.python.org/packages/source/d/distribute/distribute-0.6.30.tar.gz'
  sha1 '40dfce237883d1c02817f726128f61614dc686ff'
end

class Pypy < Formula
  homepage 'http://pypy.org/'

  if MacOS.prefer_64_bit?
    url 'https://bitbucket.org/pypy/pypy/downloads/pypy-1.9-osx64.tar.bz2'
    version '1.9'
    sha1 '825e15724419fbdb6fe215eeea044f9181883c90'
  else
    url 'http://pypy.org/download/pypy-1.4.1-osx.tar.bz2'
    version '1.4.1'
    sha1 '961470e7510c47b8f56e6cc6da180605ba058cb6'
  end

  devel do
    url 'https://bitbucket.org/pypy/pypy/downloads/pypy-2.0-beta1-osx64.tar.bz2'
    version '2.0-beta1'
    sha1 'e4938fdf33072e457fee6cb22798ec08b5a01978'
  end

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
    end
  end

  def caveats
    message = <<-EOS.undent
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

    unless MacOS.prefer_64_bit?
      message += "\n" + <<-EOS.undent
      Outdated PyPy 1.4.1 is the last version with official 32-bit Mac binary.
      Consider to build modern version yourself: http://pypy.org/download.html#building-from-source
      EOS
    end

    return message
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
    if MacOS.prefer_64_bit?
      prefix+"lib-python/2.7/distutils"
    else
      prefix+"lib-python/modified-2.5.2/distutils"
    end
  end
end
