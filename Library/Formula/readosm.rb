require 'formula'

class Readosm < Formula
  homepage 'https://www.gaia-gis.it/fossil/readosm/index'
  url 'http://www.gaia-gis.it/gaia-sins/readosm-sources/readosm-1.0.0a.tar.gz'
  sha1 '87fcbbb03ae98db1dafe8e41183891b8fe1ae5c9'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
