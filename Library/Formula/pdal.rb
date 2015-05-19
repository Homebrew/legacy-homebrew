class Pdal < Formula
  desc "Point data abstraction library"
  homepage "http://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/archive/0.9.9.tar.gz"
  sha256 "d4f91478ca55b6b775980c5c2e4c23f43b6bb4e1908ae739b1605a30b57b8a83"

  head "https://github.com/PDAL/PDAL.git"

  bottle do
    sha256 "415bd8c342d4a50803245555cafa1d3fd854135fcf7c585ce0b511e292416179" => :yosemite
    sha256 "a3ad47e4bcfbfd71f18f2677e02ac415c19a5b5f64e906200d41caba3f43e9dd" => :mavericks
    sha256 "2608de95a5dd377421873b08a72ad011bcd0309b43dda673409f2e9389817453" => :mountain_lion
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
