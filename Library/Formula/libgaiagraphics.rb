require 'formula'

class Libgaiagraphics < Formula
  homepage 'https://www.gaia-gis.it/fossil/libgaiagraphics/index'
  url 'http://www.gaia-gis.it/gaia-sins/gaiagraphics-sources/libgaiagraphics-0.5.tar.gz'
  sha1 'db9eaef329fc650da737c71aac6136088fcb6549'

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
