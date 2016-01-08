class Pdal < Formula
  desc "Point data abstraction library"
  homepage "http://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/archive/0.9.9.tar.gz"
  sha256 "d4f91478ca55b6b775980c5c2e4c23f43b6bb4e1908ae739b1605a30b57b8a83"
  head "https://github.com/PDAL/PDAL.git"
  revision 1

  bottle do
    sha256 "67a6dc161a09be18f5b71aee0b80a193edd5be777a2cb328d4e0766fc998b715" => :el_capitan
    sha256 "1e9aa94323e5d9d26e02864a19b65b2649b695eb02df13516b8ec48606e09377" => :yosemite
    sha256 "dce59dfd293f2bea47b95141f64b6196f1f8db8b4c1e74443de61b2c142ed9f4" => :mavericks
  end

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
