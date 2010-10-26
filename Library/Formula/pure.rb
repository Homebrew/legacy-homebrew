require 'formula'

class Pure < Formula
  url 'http://pure-lang.googlecode.com/files/pure-0.44.tar.gz'
  homepage 'http://code.google.com/p/pure-lang/'
  md5 '36578a3e4651c337fdff4a2fc0914e7b'

  depends_on 'llvm'
  depends_on 'gmp'
  depends_on 'readline'

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-release"
    system "make"
    system "make install"
  end
end
