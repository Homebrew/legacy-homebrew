require 'brewkit'

class Mairix <Formula
  homepage 'http://www.rpcurnow.force9.co.uk/mairix/'
  url 'http://downloads.sourceforge.net/project/mairix/mairix/0.21/mairix-0.21.tar.gz'
  md5 '821619895931711c370f51f3442a0ded'

  def install
    ENV.j1
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
