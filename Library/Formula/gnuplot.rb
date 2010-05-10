require 'formula'

class Gnuplot <Formula
  url 'http://downloads.sourceforge.net/project/gnuplot/gnuplot/4.4.0/gnuplot-4.4.0.tar.gz'
  homepage 'http://www.gnuplot.info'
  md5 'e708665bd512153ad5c35252fe499059'

  depends_on 'readline'
  depends_on 'gd'

  def install
    ENV.x11
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-readline=#{prefix}",
                          "--disable-wxwidgets"
    system "make install"
  end
end
