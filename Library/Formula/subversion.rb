require 'formula'

# On 10.5 we need newer versions of apr, neon etc.
# On 10.6 we only need a newer version of neon
class SubversionDeps <Formula
  url 'http://subversion.tigris.org/downloads/subversion-deps-1.6.9.tar.bz2'
  md5 'c480173d939a5a6d0c71c717ab71e392'

  # Note because this formula is installed into the subversion prefix
  # it is not in fact keg only
  def keg_only?
    :provided_by_osx
  end
end

class Subversion <Formula
  url 'http://subversion.tigris.org/downloads/subversion-1.6.9.tar.bz2'
  md5 '9c30a47b1d48664e7afef68bb4834c53'
  homepage 'http://subversion.apache.org/'
  
  aka :svn

  # Only need this on Snow Leopard; for Leopard the deps package 
  # builds it.
  depends_on 'neon' if MACOS_VERSION >= 10.6

  def setup_leopard
    # Slot dependencies into place
    d=Pathname.getwd
    SubversionDeps.new.brew do
      d.install Dir['*']
    end
  end

  def install
    setup_leopard if MACOS_VERSION < 10.6

    # Use existing system zlib
    # Use dep-provided other libraries
    # Don't mess with Apache modules (since we're not sudo)
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--with-ssl",
                          "--with-zlib=/usr/lib",
                          # use our neon, not OS X's 
                          "--disable-neon-version-check",
                          "--disable-mod-activation",
                          "--without-apache-libexecdir",
                          "--without-berkeley-db"
    system "make"
    system "make install"
  end
end
