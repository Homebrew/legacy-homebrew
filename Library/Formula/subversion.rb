require 'formula'

# This formula is forked between 10.5 and 10.6.
# On 10.6, we can make use of system-install deps.
# (At least, until Subversion 1.7 comes out and the system deps break again.)
#
# On 10.5, the provided Subversion is too old, so we go ahead and
# make the deps ourselves.

class SubversionDeps <Formula
  url 'http://subversion.tigris.org/downloads/subversion-deps-1.6.6.tar.bz2'
  md5 '8ec2a0daea27f86a75939d3ed09618a0'
  
  def keg_only?
    "Subversion dependencies needed on 10.5."
  end
end

class Subversion <Formula
  url 'http://subversion.tigris.org/downloads/subversion-1.6.6.tar.bz2'
  homepage 'http://subversion.tigris.org/'
  md5 'e5109da756d74c7d98f683f004a539af'

  # Only need this on Snow Leopard; for Leopard the deps package 
  # builds it.
  if MACOS_VERSION >= 10.6
    depends_on 'neon'
  end

  def setup_snow_leopard
    # Force LDFLAGS to load the HOMEBREW lib directory first. Necessary because SVN configure will
    # otherwise link to OS X neon libs in /usr/lib (and ignore --with-neon anyway)
    ENV['LDFLAGS'] += " -L#{Formula.factory('neon').lib}"
  end
  
  def setup_leopard
    # Slot dependencies into place
    d=Pathname.getwd
    SubversionDeps.new.brew do
      d.install Dir['*']
    end
  end

  def install
    if MACOS_VERSION >= 10.6
      setup_snow_leopard
    else
      setup_leopard
    end

    # Use existing system zlib
    # Use dep-provided other libraries
    # Don't mess with Apache modules (since we're not sudo)
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--with-ssl",
                          "--with-zlib=/usr/lib",
                          "--disable-neon-version-check",
                          "--disable-mod-activation",
                          "--without-apache-libexecdir",
                          "--without-berkeley-db"
    system "make"
    system "make install"
  end
end
