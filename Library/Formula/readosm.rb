require 'formula'

class Readosm < Formula
  homepage 'https://www.gaia-gis.it/fossil/readosm/index'
  url 'http://www.gaia-gis.it/gaia-sins/readosm-sources/readosm-1.0.0b.tar.gz'
  sha1 '261ff9abb7abd620da21a90513389534ec186cf6'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
