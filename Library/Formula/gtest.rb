require 'formula'

class Gtest <Formula
  url 'http://googletest.googlecode.com/files/gtest-1.5.0.tar.gz'
  homepage 'http://code.google.com/p/googletest/'
  md5 '7e27f5f3b79dd1ce9092e159cdbd0635'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
