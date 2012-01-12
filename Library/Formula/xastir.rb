require 'formula'

class Xastir < Formula
  url 'http://downloads.sourceforge.net/xastir/xastir-2.0.0.tar.gz'
  homepage 'http://www.xastir.org/'
  md5 '3e660b8168c9037b06e20b0579af3c80'

  depends_on 'proj'
  depends_on 'pcre'
  depends_on 'berkeley-db'
  depends_on 'gdal'
  depends_on 'libgeotiff'
  depends_on 'lesstif'
  depends_on 'jasper'
  depends_on 'graphicsmagick'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
