require 'formula'

# On 10.5 we need newer versions of apr, neon etc.
# On 10.6 we only need a newer version of neon
class SubversionDeps <Formula
  url 'http://subversion.tigris.org/downloads/subversion-deps-1.6.11.tar.bz2'
  md5 'da1bcdd39c34d91e434407f72b844f2f'
end

class Subversion <Formula
  url 'http://subversion.tigris.org/downloads/subversion-1.6.11.tar.bz2'
  md5 '75419159b50661092c4137449940b5cc'
  homepage 'http://subversion.apache.org/'
  
  aka 'svn'

  # Only need this on Snow Leopard; for Leopard the deps package 
  # builds it.
  depends_on 'neon' if MACOS_VERSION >= 10.6

  def options
    [
      ['--java', 'Build Java bindings.'],
      ['--universal', 'Build as a Universal Intel binary.']
    ]
  end

  def setup_leopard
    # Slot dependencies into place
    d=Pathname.getwd
    SubversionDeps.new.brew { d.install Dir['*'] }
  end

  def setup_snow_leopard
    # Check that Neon was built universal if we are building w/ --universal
    if ARGV.include? '--universal'
      neon = Formula.factory('neon')
      unless neon.installed?
        neon_arch = archs_for_command(neon.lib+'libneon.dylib')
        unless neon_arch.universal?
          opoo "A universal build was requested, but neon was already built for a single arch."
          puts "You may need to `brew rm neon` first."
        end
      end
    end
  end

  def install
    if ARGV.include? "--java" and not ARGV.include? '--universal'
      opoo "A non-Universal Java build was requested."
      puts "To use Java bindings with various Java IDEs, you might need a universal build:"
      puts "  brew install --universal --java subversion"
    end

    ENV.universal_binary if ARGV.include? '--universal'

    if MACOS_VERSION < 10.6
      setup_leopard
    else
      setup_snow_leopard
    end

    # Use existing system zlib
    # Use dep-provided other libraries
    # Don't mess with Apache modules (since we're not sudo)
    args = ["--disable-debug",
            "--prefix=#{prefix}",
            "--with-ssl",
            "--with-zlib=/usr/lib",
            # use our neon, not OS X's
            "--disable-neon-version-check",
            "--disable-mod-activation",
            "--without-apache-libexecdir",
            "--without-berkeley-db"]

    if ARGV.include? "--java"
      args << "--enable-javahl" << "--without-jikes"
    end

    system "./configure", *args
    system "make"
    system "make install"

    if ARGV.include? "--java"
      ENV.j1 # This build isn't parallel safe
      system "make javahl"
      system "make install-javahl"
    end
  end
end
