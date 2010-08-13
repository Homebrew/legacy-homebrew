require 'formula'

def build_java?; ARGV.include? "--java"; end
def build_perl?; ARGV.include? "--perl"; end
def build_python?; ARGV.include? "--python"; end
def build_universal?; ARGV.include? '--universal'; end
def with_unicode_path?; ARGV.include? '--unicode-path'; end

# On 10.5 we need newer versions of apr, neon etc.
# On 10.6 we only need a newer version of neon
class SubversionDeps <Formula
  url 'http://subversion.tigris.org/downloads/subversion-deps-1.6.12.tar.bz2'
  md5 '41a91aa26980236958ec508807003203'
end

class Subversion <Formula
  url 'http://subversion.tigris.org/downloads/subversion-1.6.12.tar.bz2'
  md5 'a4b1d0d7f3a4587c59da9c1acf9dedd0'
  homepage 'http://subversion.apache.org/'

  depends_on 'pkg-config'
  # On Snow Leopard, build a new neon. For Leopard, the deps above include this.
  depends_on 'neon' if MACOS_VERSION >= 10.6

  def options
    [
      ['--java', 'Build Java bindings.'],
      ['--perl', 'Build Perl bindings.'],
      ['--python', 'Build Python bindings.'],
      ['--universal', 'Build as a Universal Intel binary.'],
      ['--unicode-path', 'Include support for OS X unicode (but see caveats!)']
    ]
  end

  def setup_leopard
    # Slot dependencies into place
    d=Pathname.getwd
    SubversionDeps.new.brew { d.install Dir['*'] }
  end

  def check_neon_arch
    # Check that Neon was built universal if we are building w/ --universal
    neon = Formula.factory('neon')
    if neon.installed?
      neon_arch = archs_for_command(neon.lib+'libneon.dylib')
      unless neon_arch.universal?
        opoo "A universal build was requested, but neon was already built for a single arch."
        puts "You may need to `brew rm neon` first."
      end
    end
  end

  def install
    if build_java? and not build_universal?
      opoo "A non-Universal Java build was requested."
      puts "To use Java bindings with various Java IDEs, you might need a universal build:"
      puts "  brew install --universal --java subversion"
    end

    ENV.universal_binary if build_universal?

    if MACOS_VERSION < 10.6
      setup_leopard
    else
      check_neon_arch if build_universal?
    end

    # Use existing system zlib
    # Use dep-provided other libraries
    # Don't mess with Apache modules (since we're not sudo)
    args = ["--disable-debug",
            "--prefix=#{prefix}",
            "--with-ssl",
            "--with-zlib=/usr",
            # use our neon, not OS X's
            "--disable-neon-version-check",
            "--disable-mod-activation",
            "--without-apache-libexecdir",
            "--without-berkeley-db"]

    args << "--enable-javahl" << "--without-jikes" if build_java?
    args << "--with-unicode-path" if with_unicode_path?

    system "./configure", *args
    system "make"
    system "make install"

    if build_python?
      system "make swig-py"
      system "make install-swig-py"
    end

    if build_perl?
      ENV.j1 # This build isn't parallel safe
      # Remove hard-coded ppc target, add appropriate ones
      if build_universal?
        arches = "-arch x86_64 -arch i386"
      elsif MACOS_VERSION < 10.6
        arches = "-arch i386"
      else
        arches = "-arch x86_64"
      end

      inreplace "Makefile" do |s|
        s.change_make_var! "SWIG_PL_INCLUDES", "$(SWIG_INCLUDES) #{arches} -g -pipe -fno-common -DPERL_DARWIN -fno-strict-aliasing -I/usr/local/include  -I/System/Library/Perl/5.10.0/darwin-thread-multi-2level/CORE"
      end
      system "make swig-pl"
      system "make install-swig-pl"
    end

    if build_java?
      ENV.j1 # This build isn't parallel safe
      system "make javahl"
      system "make install-javahl"
    end
  end

  def patches
    if with_unicode_path?
      # Patch that modify subversion paths handling to manage unicode paths issues
      "http://gist.github.com/raw/434424/subversion-unicode-path.patch"
    end
  end

  def caveats
    s = ""

    if with_unicode_path?
      s += <<-EOS.undent
        This unicode-path version implements a hack to deal with composed/decomposed
        unicode handling on Mac OS X which is different from linux and windows.
        It is an implementation of solution 1 from
        http://svn.collab.net/repos/svn/trunk/notes/unicode-composition-for-filenames
        which _WILL_ break some setups. Please be sure you understand what you
        are asking for when you install this version.

      EOS
    end

    if build_python?
      s += <<-EOS.undent
        You may need to add the Python bindings to your PYTHONPATH from:
          #{HOMEBREW_PREFIX}/lib/svn-python

      EOS
    end

    if build_java?
      s += <<-EOS.undent
        You may need to link the Java bindings into the Java Extensions folder:
          sudo ln -s #{HOMEBREW_PREFIX}/lib/libsvnjavahl-1.dylib /Library/Java/Extensions

      EOS
    end

    return s.empty? ? nil : s
  end
end
