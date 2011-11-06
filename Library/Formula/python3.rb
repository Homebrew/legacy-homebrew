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
  url 'http://pypi.python.org/packages/source/d/distribute/distribute-0.6.24.tar.gz'
  md5 '17722b22141aba8235787f79800cc452'
end

class Python3 < Formula
  url 'http://python.org/ftp/python/3.2.2/Python-3.2.2.tar.bz2'
  homepage 'http://www.python.org/'
  md5 '9d763097a13a59ff53428c9e4d098a05'

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

  def patches
    # fix for recognizing gdbm 1.9.x databases
    # patch is already upstream: http://hg.python.org/cpython/rev/7a41855b6196
    DATA
  end

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

    system "./configure", *args
    system "make"
    ENV.j1 # Installs must be serialized
    system "make install"

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
    (effective_lib+"python3.2/distutils/distutils.cfg").write <<-EOF.undent
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
      ln_s "#{scripts_folder}/easy_install", "#{scripts_folder}/easy_install3"
    end
  end

  def caveats
    framework_caveats = <<-EOS.undent

      Framework Python was installed to:
        #{prefix}/Frameworks/Python.framework

      You may want to symlink this Framework to a standard OS X location,
      such as:
          mkdir ~/Frameworks
          ln -s "#{prefix}/Frameworks/Python.framework" ~/Frameworks
    EOS

    general_caveats = <<-EOS.undent
      Apple's Tcl/Tk is not recommended for use with 64-bit Python.
      For more information see: http://www.python.org/download/mac/tcltk/

      A "distutils.cfg" has been written, specifing the install-scripts folder as:
        #{scripts_folder}

      If you install Python packages via "python setup.py install", easy_install, pip,
      any provided scripts will go into the install-scripts folder above, so you may
      want to add it to your PATH.

      Distribute has been installed, so easy_install is available.
      To update distribute itself outside of Homebrew:
          #{scripts_folder}/easy_install pip
          #{scripts_folder}/pip install --upgrade distribute

      See: https://github.com/mxcl/homebrew/wiki/Homebrew-and-Python
    EOS

    s = general_caveats
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
end

__END__
diff --git a/Lib/dbm/__init__.py b/Lib/dbm/__init__.py
--- a/Lib/dbm/__init__.py
+++ b/Lib/dbm/__init__.py
@@ -166,7 +166,7 @@ def whichdb(filename):
         return ""
 
     # Check for GNU dbm
-    if magic == 0x13579ace:
+    if magic in (0x13579ace, 0x13579acd, 0x13579acf):
         return "dbm.gnu"
