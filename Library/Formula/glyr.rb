class Glyr < Formula
  desc "Music related metadata search engine with command-line interface and C API"
  homepage "https://github.com/sahib/glyr"
  url "https://github.com/sahib/glyr/archive/1.0.8.tar.gz"
  sha256 "0f25f291c7d956bc76d097a4a28595b6607ae8f599988018b36769ef3284b29a"

  bottle do
    cellar :any
    sha256 "7b240a58a5d1560d2d161935be8dc14c670098b76398c45afb528a8bc654b2ef" => :el_capitan
    sha256 "cdf7b602cdf76dad1371363ff5ae75d92d66a2fb683ae4a618d23ac654b1883b" => :yosemite
    sha256 "c1c0fc54aa3937936c41b92138661c760bcf03f260be7a0486c53f66273b7b20" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gettext"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    out = testpath/"cover.txt"
    system "#{bin}/glyrc", "cover", "-D", "--artist", "Beatles", "--album", "Please Please Me", "-w", out
    assert_match %r{^https?://}, out.read
  end
end
