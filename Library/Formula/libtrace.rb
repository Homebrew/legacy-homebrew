require 'formula'

class Libtrace < Formula
  homepage 'http://research.wand.net.nz/software/libtrace.php'
  url 'http://research.wand.net.nz/software/libtrace/libtrace-3.0.19.tar.bz2'
  sha1 'feadbd3ca4f1363055f305e445fdd02995c07f3f'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
