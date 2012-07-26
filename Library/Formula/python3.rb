require 'formula'

# Python 2.7.x is available as a separate formula:
# $ brew install python

# Was a Framework build requested?
def build_framework?; ARGV.include? '--framework'; end

# Are we installed or installing as a Framework?
def as_framework?
  (self.installed? and File.exists? prefix+"Frameworks/Python.framework") or build_framework?
end

class Distribute < Formula
  url 'http://pypi.python.org/packages/source/d/distribute/distribute-0.6.28.tar.gz'
  md5 'b400b532e33f78551e6847c1f5965e56'
end

class Python3 < Formula
  homepage 'http://www.python.org/'
  url 'http://python.org/ftp/python/3.2.3/Python-3.2.3.tar.bz2'
  md5 'cea34079aeb2e21e7b60ee82a0ac286b'

  depends_on 'pkg-config' => :build

  depends_on 'readline' => :optional  # Prefer over OS X's libedit
  depends_on 'sqlite'   => :optional  # Prefer over OS X's older version
  depends_on 'gdbm'     => :optional

  def options
    [
      ["--framework", "Do a 'Framework' build instead of a UNIX-style build."],
      ["--universal", "Build for both 32 & 64 bit Intel."],
      ["--static", "Build static libraries."]
    ]
  end

  # Skip binaries so modules will load; skip lib because it is mostly Python files
  skip_clean ['bin', 'lib']

  # The Cellar location of site-packages
  # This location is different for Framework builds
  def site_packages
    if as_framework?
      # If we're installed or installing as a Framework, then use that location.
      return prefix+"Frameworks/Python.framework/Versions/3.2/lib/python3.2/site-packages"
    else
      # Otherwise, use just the lib path.
      return lib+"python3.2/site-packages"
    end
  end

  def install
    args = ["--prefix=#{prefix}"]

    if ARGV.build_universal?
      args << "--enable-universalsdk=/" << "--with-universal-archs=intel"
    end

    if build_framework?
      args << "--enable-framework=#{prefix}/Frameworks"
    else
      args << "--enable-shared" unless ARGV.include? '--static'
    end

    if File.exist?( ENV['HOME']+'/.pydistutils.cfg' )
      opoo 'Detected '+ENV['HOME']+'/.pydistutils.cfg which may cause trouble.
         (See http://bugs.python.org/issue6138)'
    end

    system "./configure", *args
    system "make"
    ENV.j1 # Installs must be serialized
    system "make install"

    # The "python3" executable is forgotten if the --framework option is used.
    # Make sure homebrew symlinks it to `brew --prefix`/bin.
    if ! (File.exist? "#{bin}/python3")
      ln_s "#{bin}/python3.2", "#{bin}/python3"
    end

    # Post-install, fix up the site-packages and install-scripts folders
    # so that user-installed Python software survives minor updates, such
    # as going from 3.2.2 to 3.2.3.

    # Remove the site-packages that Python created in its Cellar.
    site_packages.rmtree

    # Create a site-packages in the prefix.
    prefix_site_packages.mkpath

    # Symlink the prefix site-packages into the cellar.
    ln_s prefix_site_packages, site_packages

    # Tell distutils-based installers where to put scripts
    scripts_folder.mkpath
    (effective_lib/"python3.2/distutils/distutils.cfg").write <<-EOF.undent
      [install]
      install-scripts=#{scripts_folder}
    EOF

    # Install distribute. The user can then do:
    # $ easy_install pip
    # $ pip install --upgrade distribute
    # to get newer versions of distribute outside of Homebrew.
    Distribute.new.brew do
      system "#{bin}/python3.2", "setup.py", "install"

      # Symlink to easy_install3 to match python3 command.
      unless (scripts_folder/'easy_install3').exist?
        ln_s "#{scripts_folder}/easy_install", "#{scripts_folder}/easy_install3"
      end
    end
  end

  def caveats
    # Since right now, python 2.x is still the default (for homebrew), we
    # suggest only a symlink to the framework Version 3.2 and not "Current".
    framework_caveats = <<-EOS.undent

      Framework Python was installed to:
        #{prefix}/Frameworks/Python.framework

      You may want to symlink this Framework to a standard OS X location,
      such as:
        mkdir -p ~/Library/Frameworks/Python.framework/Versions
        ln -s "#{prefix}/Frameworks/Python.framework/Versions/3.2" ~/Library/Frameworks/Python.framework/Versions/3.2
    EOS

    # Tk warning only for 10.6 (not for Lion)
    tk_caveats = <<-EOS.undent
      Apple's Tcl/Tk is not recommended for use with Python on Mac OS X 10.6.
      For more information see: http://www.python.org/download/mac/tcltk/

    EOS

    general_caveats = <<-EOS.undent
      A "distutils.cfg" has been written, specifing the install-scripts folder as:
        #{scripts_folder}

      If you install Python packages via "python3 setup.py install", easy_install3,
      pip-3.2, any provided scripts will go into the install-scripts folder above, so
      you may want to add it to your PATH.

      Distribute has been installed, so easy_install is available.
      To update distribute itself outside of Homebrew:
        #{scripts_folder}/easy_install3 pip
        #{scripts_folder}/pip-3.2 install --upgrade distribute

      See: https://github.com/mxcl/homebrew/wiki/Homebrew-and-Python
    EOS

    s = general_caveats
    s += tk_caveats if not MacOS.lion?
    s += framework_caveats if as_framework?
    return s
  end

  # lib folder,taking into account whether we are a Framework build or not
  def effective_lib
    # If we're installed or installing as a Framework, then use that location.
    return prefix+"Frameworks/Python.framework/Versions/3.2/lib" if as_framework?
    # Otherwise use just 'lib'
    return lib
  end

  # include folder,taking into account whether we are a Framework build or not
  def effective_include
    # If we're installed or installing as a Framework, then use that location.
    return prefix+"Frameworks/Python.framework/Versions/3.2/include" if as_framework?
    # Otherwise use just 'include'
    return include
  end

  # The Cellar location of site-packages
  def site_packages
    effective_lib+"python3.2/site-packages"
  end

  # The HOMEBREW_PREFIX location of site-packages
  def prefix_site_packages
    HOMEBREW_PREFIX+"lib/python3.2/site-packages"
  end

  # Where distribute will install executable scripts
  def scripts_folder
    HOMEBREW_PREFIX+"share/python3"
  end

  # See: https://github.com/mxcl/homebrew/pull/10487
  def test
    `#{bin}/python3 -c 'from decimal import Decimal; print(Decimal(4) / Decimal(2))'`.chomp == '2'
  end
end
