class Pdal < Formula
  desc "Point data abstraction library"
  homepage "http://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/archive/0.9.9.tar.gz"
  sha256 "d4f91478ca55b6b775980c5c2e4c23f43b6bb4e1908ae739b1605a30b57b8a83"
  head "https://github.com/PDAL/PDAL.git"
  revision 2

  bottle do
    sha256 "84c4c25aaffc330d2f994b4f7aafd28d5d5a4f727eb354a84bfbd5313c04155a" => :el_capitan
    sha256 "90b00596d80412ea55f292a3b0d030eb7e4eb2136edaea5fabf7b4e80d7617aa" => :yosemite
    sha256 "7e8273951749b40d90029d152f70a708876879c3a1f8fd2cdc46308a59c2b4e2" => :mavericks
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
