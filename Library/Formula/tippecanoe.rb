class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.9.2.tar.gz"
  sha256 "9208a5a5fe843c34a08c6ae413c4e259defca4c037dd2c72781b3d7a7c819297"

  bottle do
    cellar :any
    sha256 "bff1437ec321439aa9ee0ef2d543468a6c2882f253acb9897a45cfa1c7fa724c" => :el_capitan
    sha256 "44fb1ee6ca45dc663d9e67489889fcfc3eeb689c5e3b3cc7b62cd1ae8f9a92d7" => :yosemite
    sha256 "8227aacc99a462502db622116d4fec5664d2d8cc001738a0e85f8d86483b3f21" => :mavericks
  end

  depends_on "protobuf-c"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.json").write <<-EOS.undent
      {"type":"Feature","properties":{},"geometry":{"type":"Point","coordinates":[0,0]}}
    EOS
    safe_system "#{bin}/tippecanoe", "-o", "test.mbtiles", "test.json"
    assert File.exist?("#{testpath}/test.mbtiles"), "tippecanoe generated no output!"
  end
end
