require 'formula'

class Fetchmail <Formula
  homepage 'http://www.fetchmail.info/'
  url 'http://download.berlios.de/fetchmail/fetchmail-6.3.13.tar.bz2'
  md5 'db792fb311bc358e95ed0437389269ac'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
