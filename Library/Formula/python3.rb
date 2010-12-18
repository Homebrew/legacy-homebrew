require 'formula'

<<-COMMENTS
Versions
--------
This formula is currently tracking version 3.1.x.

Python 2.x is available as a separate formula:
  brew install python

COMMENTS

# Was a Framework build requested?
def build_framework?; ARGV.include? '--framework'; end

# Are we installed or installing as a Framework?
def as_framework?
  (self.installed? and File.exists? prefix+"Frameworks/Python.framework") or build_framework?
end

class Python3 <Formula
  url 'http://www.python.org/ftp/python/3.1.3/Python-3.1.3.tar.bz2'
  homepage 'http://www.python.org/'
  md5 'ad5e5f1c07e829321e0a015f8cafe245'

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

  def site_packages
    # The Cellar location of site-packages
    if as_framework?
      # If we're installed or installing as a Framework, then use that location.
      return prefix+"Frameworks/Python.framework/Versions/3.1/lib/python3.1/site-packages"
    else
      # Otherwise, use just the lib path.
      return lib+"python3.1/site-packages"
    end
  end

  def prefix_site_packages
    # The HOMEBREW_PREFIX location of site-packages
    HOMEBREW_PREFIX+"lib/python3.1/site-packages"
  end

  def install
    # --with-computed-gotos requires addressable labels in C;
    # both gcc and LLVM support this, so switch it on.
    args = ["--prefix=#{prefix}", "--with-computed-gotos"]

    if ARGV.include? '--universal'
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

  def caveats
    <<-EOS.undent
      The site-packages folder for this Python is:
        #{site_packages}

      We've added a "homebrew.pth" file to also include:
        #{prefix_site_packages}
    EOS
  end
end
