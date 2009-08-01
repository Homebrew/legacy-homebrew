require 'brewkit'

class SubversionDeps <UnidentifiedFormula
  @url='http://subversion.tigris.org/downloads/subversion-deps-1.6.3.tar.bz2'
  @md5='22d3687ae93648fcecf945c045931272'
end

class Subversion <Formula
  @url='http://subversion.tigris.org/downloads/subversion-1.6.3.tar.bz2'
  @homepage='http://subversion.tigris.org/'
  @md5='8bf7637ac99368db0890e3f085fa690d'

  def install
    # Slot dependencies into place
    d=Pathname.getwd
    SubversionDeps.new.brew do
      d.install Dir['*']
    end

    # Use existing system zlib
    # Use dep-provided other libraries
    # Don't mess with Apache modules (since we're not sudo)
    system "./configure --disable-debug --prefix='#{prefix}' --with-zlib=/usr/lib --disable-mod-activation --without-apache-libexecdir"
    system "make"
    system "make install"
  end
end
