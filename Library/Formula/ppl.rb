require 'formula'

class Ppl < Formula
  homepage 'http://bugseng.com/products/ppl/'
  url 'http://bugseng.com/products/ppl/download/ftp/releases/1.0/ppl-1.0.tar.gz'
  sha1 '5f543206cc9de17d48ff797e977547b61b40ab2c'

  depends_on 'gmp'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-optimization=sspeed"
    system "make install"
  end
end
