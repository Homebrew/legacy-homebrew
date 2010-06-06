require 'formula'

class Celt <Formula
  url 'http://downloads.xiph.org/releases/celt/celt-0.7.1.tar.gz'
  homepage 'http://www.celt-codec.org/'
  md5 'c7f6b8346e132b1a48dae0eff77ea9f0'

  depends_on 'libogg' => :optional

  def install
    # 1 Test failed with llvm-gcc
    ENV.gcc_4_2

    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--enable-new-plc"
    system "make check"
    system "make install"
  end
end
