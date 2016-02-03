class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.6.4.tar.gz"
  sha256 "a95e7f054671b24c0a8ac61b40a1cc379f58e9a4273172671409631e136da9d3"

  bottle do
    cellar :any
    sha256 "ee22cf0295f3d4bd08819f25681870821eef5c0e0f31b6f618512a1bc932d609" => :el_capitan
    sha256 "86f88750b3f09d455a17045b88b7a4dbf49904abe37f9512065a1562f1e1b2fd" => :yosemite
    sha256 "29f0b3edda5115bfbec0b8258810dcde8cb9826f4e7d434851c0ad7446f4caf5" => :mavericks
  end

  depends_on "protobuf-c"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    path = testpath/"test.json"
    path.write <<-EOS.undent
      {"type":"Feature","properties":{},"geometry":{"type":"Point","coordinates":[0,0]}}
    EOS
    output = `#{bin}/tippecanoe -o test.mbtiles #{path}`.strip
    assert_equal 0, $?.exitstatus
    assert_equal "using layer 0 name test", output
  end
end
