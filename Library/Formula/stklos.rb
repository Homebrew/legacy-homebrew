require 'formula'

class Stklos < Formula
  url 'http://www.stklos.net/download/stklos-1.01.tar.gz'
  homepage 'http://www.stklos.net/'
  md5 '2c370627c3abd07c30949b2ee7d3d987'

  depends_on 'gmp'
  depends_on 'pcre'

  # it fails with LLVM while building its internal bdw-gc,
  # for the same reason as bdw-gc itself.
  fails_with_llvm "LLVM gives an unsupported inline asm error."

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
