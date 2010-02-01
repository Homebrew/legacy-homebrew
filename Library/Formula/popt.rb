require 'formula'

class Popt <Formula
  @url='http://rpm5.org/files/popt/popt-1.15.tar.gz'
  @homepage='http://rpm5.org'
  @md5='c61ef795fa450eb692602a661ec8d7f1'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
