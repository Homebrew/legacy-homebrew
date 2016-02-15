class Avce00 < Formula
  desc "Make Arc/Info (binary) Vector Coverages appear as E00"
  homepage "http://avce00.maptools.org/avce00/index.html"
  url "http://avce00.maptools.org/dl/avce00-2.0.0.tar.gz"
  sha256 "c0851f86b4cd414d6150a04820491024fb6248b52ca5c7bd1ca3d2a0f9946a40"

  bottle do
    cellar :any
    sha256 "56e15b29411b2947d9a842d91ae713e16566aa59e297e06f7d4de4b301847e66" => :yosemite
    sha256 "55990b93f7fe4639c6fdf29c4cc6c5791c6178c8661e22ef9e0dd64606532f56" => :mavericks
    sha256 "4f114d3d8872cbf9e2df2c2ed2d4962b65b39efc568faf78eb5b2f47552a39da" => :mountain_lion
  end

  conflicts_with "gdal", :because => "both install a cpl_conv.h header"

  def install
    system "make", "CC=#{ENV.cc}"
    bin.install "avcimport", "avcexport", "avcdelete", "avctest"
    lib.install "avc.a"
    include.install Dir["*.h"]
  end

  test do
    touch testpath/"test"
    system "#{bin}/avctest", "-b", "test"
  end
end
