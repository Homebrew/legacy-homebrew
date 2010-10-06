require 'formula'

class Pure < Formula
  url 'http://pure-lang.googlecode.com/files/pure-0.44.tar.gz'
  homepage 'http://code.google.com/p/pure-lang/'
  md5 '1b857543f0574e7ffff243bbea9fa712'

  depends_on 'llvm'
  depends_on 'gmp'
  depends_on 'readline'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-release"
    system "make"
    system "make install"
  end
end
