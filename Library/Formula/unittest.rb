require 'formula'

class Unittest < Formula
  homepage 'http://unittest.red-bean.com/'
  url 'http://unittest.red-bean.com/tar/unittest-0.50-62.tar.gz'
  sha1 '4a5a5683f26d15c46911a163411e56968c441849'

  fails_with :llvm do
    build 2334
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
