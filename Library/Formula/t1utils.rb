require 'formula'

class T1utils < Formula
  url 'http://www.lcdf.org/~eddietwo/type/t1utils-1.35.tar.gz'
  homepage 'http://www.lcdf.org/~eddietwo/type/'
  md5 '20e4cd3ffe81f01eff02a5e2320d95b7'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
