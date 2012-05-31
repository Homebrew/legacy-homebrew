require 'formula'

class Unittest < Formula
  url 'http://unittest.red-bean.com/tar/unittest-0.50-62.tar.gz'
  homepage 'http://unittest.red-bean.com/'
  md5 'e77615162141b23a78adcda929d58d61'

  fails_with :llvm do
    build 2334
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
