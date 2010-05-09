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

  def setup_leopard
    # Slot dependencies into place
    d=Pathname.getwd
    SubversionDeps.new.brew { d.install Dir['*'] }
  end

  def install
    setup_leopard if MACOS_VERSION < 10.6

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
      args << "--enable-javalhl" << "--without-jikes"
    end

    system "./configure", *args

    system "make"
    system "make install"

    if ARGV.include? "--java"
      ENV.j1
      system "make javahl"
      system "make install-javahl"
    end
  end
end
