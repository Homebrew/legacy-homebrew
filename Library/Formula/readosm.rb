require 'formula'

class Readosm < Formula
  homepage 'https://www.gaia-gis.it/fossil/readosm/index'
  url 'http://www.gaia-gis.it/gaia-sins/readosm-sources/readosm-1.0.0b.tar.gz'
  sha1 '261ff9abb7abd620da21a90513389534ec186cf6'

  bottle do
    cellar :any
    sha1 "048daf9074d277eb64b3d8f479ac3c2cf636d932" => :yosemite
    sha1 "6c6aaf7961bd728538787e3f9b09022d59ad350e" => :mavericks
    sha1 "1f59bbb3b9d0a13d56fc592ae60c67e56f3d9d0d" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
