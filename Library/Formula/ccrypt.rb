require 'formula'

class Ccrypt < Formula
  url 'http://ccrypt.sourceforge.net/download/ccrypt-1.9.tar.gz'
  homepage 'http://ccrypt.sourceforge.net/'
  md5 'c3f78019d7a166dd66f1d4b1390c62c2'

  def install
    # Tests fail with clang (build 318) at higher optimization
    ENV.no_optimization if ENV.compiler == :clang

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
    system "make check"
  end
end
