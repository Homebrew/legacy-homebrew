require 'formula'

class Spatialindex < Formula
  homepage 'http://libspatialindex.github.io'
  url "http://download.osgeo.org/libspatialindex/spatialindex-src-1.8.1.tar.gz"
  sha1 "c05f8d081316a163aef117b7fd99811539ec421c"

  bottle do
    cellar :any
    sha1 "54cf31266bd31f2da68f907357ea82660d3e69a7" => :mavericks
    sha1 "39d6c3cae399cfe21ce654099d91e235db568e6e" => :mountain_lion
    sha1 "4b3a2cc81e92d7129b55c90a0c35014b200acf1d" => :lion
  end

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
