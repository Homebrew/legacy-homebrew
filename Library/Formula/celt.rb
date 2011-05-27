require 'formula'

class Celt < Formula
  url 'http://downloads.xiph.org/releases/celt/celt-0.8.1.tar.gz'
  homepage 'http://www.celt-codec.org/'
  sha256 'cbaa8d2ba4d4807f29a5ed40b9f2be233f988c6e3ac8dd1737b6e2ac20174542'

  depends_on 'libogg' => :optional

  fails_with_llvm "1 test failed with llvm-gcc"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-new-plc"
    system "make check"
    system "make install"
  end
end
