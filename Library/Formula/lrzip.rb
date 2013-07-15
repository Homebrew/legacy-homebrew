require 'formula'

class Lrzip < Formula
  homepage 'http://lrzip.kolivas.org'
  url 'http://ck.kolivas.org/apps/lrzip/lrzip-0.614.tar.bz2'
  sha1 'b3c2149c9ca353f595d7f2774262244cc56a7500'

  depends_on 'pkg-config' => :build
  depends_on "lzo"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
