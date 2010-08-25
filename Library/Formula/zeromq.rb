require 'formula'

class Zeromq <Formula
  url 'http://www.zeromq.org/local--files/area:download/zeromq-2.0.7.tar.gz'
  homepage 'http://www.zeromq.org/'
  md5 'c9cb3ee4499df1781f8ddc03c20d656b'

  def install
    fails_with_llvm "Compiling with LLVM gives a segfault while linking."
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
