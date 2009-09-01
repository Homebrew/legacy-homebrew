require 'brewkit'

class SubversionDeps <Formula
  @url='http://subversion.tigris.org/downloads/subversion-deps-1.6.5.tar.bz2'
  @md5='8272316e1670d4d2bea451411e438bde'
end

class Subversion <Formula
  @url='http://subversion.tigris.org/downloads/subversion-1.6.5.tar.bz2'
  @homepage='http://subversion.tigris.org/'
  @md5='1a53a0e72bee0bf814f4da83a9b6a636'

  def install
    # Slot dependencies into place
    d=Pathname.getwd
    SubversionDeps.new.brew do
      d.install Dir['*']
    end

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
