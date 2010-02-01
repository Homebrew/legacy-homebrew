require 'formula'

class Celt <Formula
  url 'http://downloads.xiph.org/releases/celt/celt-0.7.0.tar.gz'
  homepage 'http://www.celt-codec.org/'
  md5 '0bb72abec367f4ef12551f79dda11b23'

  depends_on 'libogg'

  def install
    # 1 Test failed with llvm-gcc
    ENV.gcc_4_2

    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make check"
    system "make install"
  end
end
