class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/v1.8.1.tar.gz"
  sha256 "f75c48a61a0517675a52bb9b152d33c742b5df1d774734d9c216299788cb2a6f"

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

    system("#{bin}/tippecanoe -o #{testpath}/test.mbtiles #{path}")

    assert_equal 0, $?.exitstatus
    assert File.exist?(File.join(testpath, "test.mbtiles"))
  end
end
