require 'formula'

class Xastir < Formula
  homepage 'http://www.xastir.org/'
  url 'http://downloads.sourceforge.net/xastir/xastir-2.0.0.tar.gz'
  sha1 '4dcb6445df134362353a49d34acf866250f205b7'

  depends_on 'proj'
  depends_on 'pcre'
  depends_on 'berkeley-db'
  depends_on 'gdal'
  depends_on 'libgeotiff'
  depends_on 'lesstif'
  depends_on 'jasper'
  depends_on 'graphicsmagick'

  def install
    # find Homebrew's libpcre
    ENV.append 'LDFLAGS', "-L#{HOMEBREW_PREFIX}/lib"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
