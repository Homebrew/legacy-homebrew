require 'formula'

class Icoutils < Formula
  url 'http://savannah.nongnu.org/download/icoutils/icoutils-0.29.1.tar.bz2'
  homepage 'http://www.nongnu.org/icoutils/'
  md5 'b58f375e0f8731595e8d0ecdc3a0acb9'

  def install
    ENV.libpng
    system "./configure", "--disable-dependency-tracking",
                          "--disable-rpath",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
