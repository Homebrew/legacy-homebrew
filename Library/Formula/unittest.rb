require 'formula'

class Unittest < Formula
  url 'http://unittest.red-bean.com/tar/unittest-0.50-62.tar.gz'
  homepage 'http://unittest.red-bean.com/'
  sha1 '95d15db78e60d0f96b321177c2f3f52c619634b3'

  fails_with :llvm do
    build 2334
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
