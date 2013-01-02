require 'formula'

class Libgaiagraphics < Formula
  homepage 'https://www.gaia-gis.it/fossil/libgaiagraphics/index'
  url 'http://www.gaia-gis.it/gaia-sins/gaiagraphics-sources/libgaiagraphics-0.4b.tar.gz'
  sha1 'd045ad6d22db9e67ba410a62b9398c337786fe53'

  depends_on 'pkg-config' => :build
  depends_on 'libgeotiff'
  depends_on 'jpeg'
  depends_on 'cairo'
  depends_on :libpng

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
