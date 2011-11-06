require 'formula'

class Readpst < Formula
  url 'http://www.five-ten-sg.com/libpst/packages/libpst-0.6.49.tar.gz'
  homepage 'http://www.five-ten-sg.com/libpst/'
  md5 'a0a0f927e82ab14bb042bd8bbd97c312'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}",
                          "--disable-python"
    system "make"
    ENV.j1 # Install is not parallel-safe
    system "make install"
  end
end
