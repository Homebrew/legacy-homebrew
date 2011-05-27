require 'formula'

# This formula is for Python version 3.2.
# Python 2.7.1 is available as a separate formula:
# $ brew install python

# Was a Framework build requested?
def build_framework?; ARGV.include? '--framework'; end

# Are we installed or installing as a Framework?
def as_framework?
  (self.installed? and File.exists? prefix+"Frameworks/Python.framework") or build_framework?
end

class Python3 < Formula
  url 'http://www.python.org/ftp/python/3.2/Python-3.2.tar.bz2'
  homepage 'http://www.python.org/'
  md5 '92e94b5b6652b96349d6362b8337811d'

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

  # The HOMEBREW_PREFIX location of site-packages
  # We write a .pth file in the Cellar site-packages to here
  def prefix_site_packages
    HOMEBREW_PREFIX+"lib/python3.2/site-packages"
  end

  def install
    # --with-computed-gotos requires addressable labels in C.
    # Both gcc and LLVM support this, so switch it on.
    args = ["--prefix=#{prefix}", "--with-computed-gotos"]

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

    # Add the Homebrew prefix path to site-packages via a .pth
    prefix_site_packages.mkpath
    (site_packages+"homebrew.pth").write prefix_site_packages
  end

  def caveats; <<-EOS.undent
    Apple's Tcl/Tk is not recommended for use with 64-bit Python.
    For more information see: http://www.python.org/download/mac/tcltk/

    The site-packages folder for this Python is:
      #{site_packages}

    We've added a "homebrew.pth" file to also include:
      #{prefix_site_packages}
    EOS
  end
end
