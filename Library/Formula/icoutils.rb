require 'formula'

class Icoutils < Formula
  homepage 'http://www.nongnu.org/icoutils/'
  url 'http://savannah.nongnu.org/download/icoutils/icoutils-0.29.1.tar.bz2'
  sha1 '312036e81d8c1800fb21ca6fc6b6ff3219e2c030'

  depends_on :libpng

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-rpath",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
