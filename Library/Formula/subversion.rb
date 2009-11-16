require 'formula'

# On 10.5 we need newer versions of apr, neon etc.
# On 10.6 we only need a newer version of neon
class SubversionDeps <Formula
  url 'http://subversion.tigris.org/downloads/subversion-deps-1.6.6.tar.bz2'
  md5 '8ec2a0daea27f86a75939d3ed09618a0'

  # Note because this formula is installed into the subversion prefix
  # it is not in fact keg only
  def keg_only?
    :provided_by_osx
  end
end

class Subversion <Formula
  url 'http://subversion.tigris.org/downloads/subversion-1.6.6.tar.bz2'
  homepage 'http://subversion.tigris.org/'
  md5 'e5109da756d74c7d98f683f004a539af'
  
  aka :svn

  # Only need this on Snow Leopard; for Leopard the deps package 
  # builds it.
  if MACOS_VERSION >= 10.6
    depends_on 'neon'
  end

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
