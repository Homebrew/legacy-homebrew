class Spatialindex < Formula
  desc "General framework for developing spatial indices"
  homepage "https://libspatialindex.github.io"
  url "http://download.osgeo.org/libspatialindex/spatialindex-src-1.8.5.tar.gz"
  sha256 "7caa46a2cb9b40960f7bc82c3de60fa14f8f3e000b02561b36cbf2cfe6a9bfef"

  bottle do
    cellar :any
    sha256 "34d1e02dd4133ed67a8a4c299044e277e1e9cfc982962c50c44c751723eb85cb" => :el_capitan
    sha256 "907f40e614218622fd9fecc0a542adcdf768446a198ef4cc972b30a7eb5e6cd3" => :yosemite
    sha256 "33e053a03ea77bc87c3aab4f8319461baab56824e3c933cb09398e6df1b542ba" => :mavericks
    sha256 "401c416f243996ac4f6bca61a871aec7fb8811f8aef6073dfc62c64dfe2650f7" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
