class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.9.7.tar.gz"
  sha256 "c90d4403f99d7b5bdcbca4a62bbefb1044dbf8551f91c334c3f374e15ba33f82"

  bottle do
    cellar :any
    sha256 "3f06a8864fc82db2ad2588ffa0a5869fbbe28ffe22b1be2941cf39e2d7dc474e" => :el_capitan
    sha256 "b12932420c34241e143b8adcd73cfa66dcfd2ab5cc3c0c04ad14031e360c9ce8" => :yosemite
    sha256 "ff33ac9f8def8cfd7afdbee3c285e59b12f60ad597ae3689ead750760147f612" => :mavericks
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
