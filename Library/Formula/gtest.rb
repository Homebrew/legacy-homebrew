require 'formula'

class Gtest <Formula
  url 'http://googletest.googlecode.com/files/gtest-1.4.0.tar.gz'
  homepage 'http://code.google.com/p/googletest/'
  md5 'ec1dd5ab07cde5da033b1d631e621167'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
