class Spatialindex < Formula
  desc "General framework for developing spatial indices"
  homepage "https://libspatialindex.github.io"
  url "http://download.osgeo.org/libspatialindex/spatialindex-src-1.8.5.tar.gz"
  sha256 "7caa46a2cb9b40960f7bc82c3de60fa14f8f3e000b02561b36cbf2cfe6a9bfef"

  bottle do
    cellar :any
    sha256 "34d1e02dd4133ed67a8a4c299044e277e1e9cfc982962c50c44c751723eb85cb" => :el_capitan
    sha1 "ed7c92a7da78e4e7e5294ea52cd05c344094af98" => :yosemite
    sha1 "07e4fe6747d4db327fadc2e3e4f12a975ff4aaba" => :mavericks
    sha1 "2122a70a3dd9d966d8fdc7b9e0e285515356dd98" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
