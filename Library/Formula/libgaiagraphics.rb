require 'formula'

class Libgaiagraphics < Formula
  homepage 'https://www.gaia-gis.it/fossil/libgaiagraphics/index'
  url 'http://www.gaia-gis.it/gaia-sins/gaiagraphics-sources/libgaiagraphics-0.4b.tar.gz'
  md5 '6e7c703faad9de3beea296aa9508eec2'

  depends_on 'libgeotiff'
  depends_on 'jpeg'

  # Leopard's Cairo is too old.
  depends_on 'cairo' if MacOS.leopard?

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
