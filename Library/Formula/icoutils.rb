require 'formula'

class Icoutils < Formula
  homepage 'http://www.nongnu.org/icoutils/'
  url 'http://savannah.nongnu.org/download/icoutils/icoutils-0.31.0.tar.bz2'
  sha1 '2712acd33c611588793562310077efd2ff35dca5'
  revision 1

  depends_on 'libpng'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-rpath",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
