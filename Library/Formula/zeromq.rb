require 'formula'

class Zeromq <Formula
  url 'http://www.zeromq.org/local--files/area:download/zeromq-2.0.8.tar.gz'
  homepage 'http://www.zeromq.org/'
  md5 '6a5c362deaaa24e0e94b42e13f68da51'

  def install
    fails_with_llvm "Compiling with LLVM gives a segfault while linking."
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
