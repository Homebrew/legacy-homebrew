require 'formula'

class Libtrace < Formula
  homepage 'http://research.wand.net.nz/software/libtrace.php'
  url 'http://research.wand.net.nz/software/libtrace/libtrace-3.0.17.tar.bz2'
  sha1 'd018f612f7d266c59547fb5b1a0442001fb45477'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
