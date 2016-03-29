class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.9.5.tar.gz"
  sha256 "51240d20656f126dbf067c71a7bd8fe9061820f1e672532273177374d8b51bb1"

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
