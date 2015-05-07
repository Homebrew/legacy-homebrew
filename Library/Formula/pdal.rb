class Pdal < Formula
  homepage "http://pointcloud.org"
  url "https://github.com/PDAL/PDAL/archive/0.9.9.tar.gz"
  sha256 "d4f91478ca55b6b775980c5c2e4c23f43b6bb4e1908ae739b1605a30b57b8a83"

  head "https://github.com/PDAL/PDAL.git"

  depends_on "cmake" => :build
  depends_on "gdal"

  if MacOS.version < :mavericks
    depends_on "boost" => "c++11"
  else
    depends_on "boost"
  end

  def install
    ENV.cxx11 if MacOS.version < :mavericks
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    doc.install "examples", "test"
  end

  test do
    system bin/"pdal", "info", doc/"test/data/las/interesting.las"
  end
end
