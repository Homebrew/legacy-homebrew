require 'brewkit'

class Subversion <Formula
  @url='http://subversion.tigris.org/downloads/subversion-1.6.5.tar.bz2'
  @homepage='http://subversion.tigris.org/'
  @md5='1a53a0e72bee0bf814f4da83a9b6a636'

  depends_on 'neon'

  def install
    # Force LDFLAGS to load the HOMEBREW lib directory first. Necessary because SVN configure will
    # otherwise link to OS X neon libs in /usr/lib (and ignore --with-neon anyway)
    ENV['LDFLAGS'] += " -L#{Formula.factory('neon').lib}"

    # Use existing system zlib, dep-provided other libraries
    # Don't mess with Apache modules (since we're not sudo)
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--with-ssl",
                          "--with-zlib=/usr/lib",
                          "--disable-mod-activation",
                          "--without-apache-libexecdir",
                          "--without-berkeley-db"
    system "make"
    system "make install"
  end
end
