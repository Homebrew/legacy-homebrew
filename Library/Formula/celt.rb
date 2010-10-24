require 'formula'

class Celt <Formula
  url 'http://downloads.xiph.org/releases/celt/celt-0.7.1.tar.gz'
  homepage 'http://www.celt-codec.org/'
  md5 'c7f6b8346e132b1a48dae0eff77ea9f0'

  depends_on 'libogg' => :optional

  def install
    fails_with_llvm "1 test failed with llvm-gcc"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-new-plc"
    system "make check"
    system "make install"
  end
end
