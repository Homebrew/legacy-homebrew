class Glyr < Formula
  desc "Music related metadata search engine with command-line interface and C API"
  homepage "https://github.com/sahib/glyr"
  url "https://github.com/sahib/glyr/archive/1.0.8.tar.gz"
  sha256 "0f25f291c7d956bc76d097a4a28595b6607ae8f599988018b36769ef3284b29a"

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
