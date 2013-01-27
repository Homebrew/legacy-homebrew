require 'formula'

class Unittest < Formula
  homepage 'http://unittest.red-bean.com/'
  url 'http://unittest.red-bean.com/tar/unittest-0.50-62.tar.gz'
  sha1 '95d15db78e60d0f96b321177c2f3f52c619634b3'

  fails_with :llvm do
    build 2334
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
