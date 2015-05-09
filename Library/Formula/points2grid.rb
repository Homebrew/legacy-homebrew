class Points2grid < Formula
  homepage "https://github.com/CRREL/points2grid"
  url "https://github.com/CRREL/points2grid/archive/1.3.0.tar.gz"
  sha256 "87acdfd336fac20d2c2a22926b045c7f3f0fc925769a87393aff28b8c351c62b"
  revision 1

  bottle do
    cellar :any
    sha256 "6e840a87ecf89f094ba9a5d6b6ba04be42c82a0b2a8946d199f4d75ea1e8fecd" => :yosemite
    sha256 "65a1c03a002aef1c5ec7a921494b519bad37dfbadfebf42a6e4a1bc6a902fa27" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "gdal"

  def install
    args = std_cmake_args + ["-DWITH_GDAL=ON"]
    libexec.install "example.las"
    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    mktemp do
      system bin/"points2grid",
             "-i", libexec/"example.las",
             "-o", "example",
             "--max", "--output_format", "grid"
      assert_equal 5, `grep -c '423.820000' < example.max.grid`.strip.to_i
    end
  end
end
