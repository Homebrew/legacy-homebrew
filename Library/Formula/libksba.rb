require 'formula'

class Libksba <Formula
	depends_on 'libgpg-error'

  url 'ftp://ftp.gnupg.org/gcrypt/libksba/libksba-1.0.7.tar.bz2'
  homepage 'http://www.gnupg.org/related_software/libksba/index.en.html'
  md5 'eebce521a90600369c33c5fa6b9bbbd8'


  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
