class Pdal < Formula
  desc "Point data abstraction library"
  homepage "http://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/archive/1.1.0.tar.gz"
  sha256 "70e0c84035b3fdc75c4eb72dde62a7a2138171d249f2a607170f79d5cafe589d"
  head "https://github.com/PDAL/PDAL.git"

  bottle do
    sha256 "21dc2f8487f310e9ccafbb625639c2fb795ff915b5ace70272c1f101760d05da" => :el_capitan
    sha256 "7b7d7a29d450d3e6f4a8abce3b3ac24900419d753e3b64726d4991fe6e0219b7" => :yosemite
    sha256 "cd3a166ed19422b0cc9eba5de4e37031cc8c1cfe29973373c54d48e72e2f68b2" => :mavericks
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
