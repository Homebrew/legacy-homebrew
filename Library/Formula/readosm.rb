require 'formula'

class Readosm < Formula
  homepage 'https://www.gaia-gis.it/fossil/readosm/index'
  url 'http://www.gaia-gis.it/gaia-sins/readosm-sources/readosm-1.0.0.tar.gz'
  md5 'ed50a748d430612ecbead6ad3d271410'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
