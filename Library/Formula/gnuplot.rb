require 'brewkit'

class Gnuplot <Formula
  @url='http://downloads.sourceforge.net/project/gnuplot/gnuplot/4.2.6/gnuplot-4.2.6.tar.gz'
  @homepage='http://www.gnuplot.info/'
  @md5='c10468d74030e8bed0fd6865a45cf1fd'
  
  depends_on 'readline'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--with-readline=#{prefix}/lib"
    system "make install"
  end
end
