class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.9.3.tar.gz"
  sha256 "5d5d4b19b1113cc189d0f59784876c5b0382a04c6948dd0d0f94aef568585364"

  bottle do
    cellar :any
    sha256 "d32d7d573ef7ad7db6263f41c7ca2aa3ec083cb5b115f1a16b34668acb9cf76c" => :el_capitan
    sha256 "a48233e73e259b60ae25cbf62a7ffcb2d192af43549d0937f2511fb4c0567966" => :yosemite
    sha256 "65196ed56d9831f9dc2558e380d1b6ff5136cc59421b014926b1db7379ed9f75" => :mavericks
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
