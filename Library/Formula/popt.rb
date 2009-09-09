require 'brewkit'

class Popt <Formula
  @url='http://rpm5.org/files/popt/popt-1.14.tar.gz'
  @homepage='http://rpm5.org'
  @md5='4f90a07316eb825604dd10ae4f9f3f04'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
