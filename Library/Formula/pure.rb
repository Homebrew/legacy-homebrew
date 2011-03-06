require 'formula'

class Pure < Formula
  url 'http://pure-lang.googlecode.com/files/pure-0.46.tar.gz'
  homepage 'http://code.google.com/p/pure-lang/'
  sha1 '0b5304463d4c50474936d7921f884e029a5d1ccc'

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
