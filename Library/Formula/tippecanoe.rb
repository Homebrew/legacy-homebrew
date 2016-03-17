class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.9.3.tar.gz"
  sha256 "5d5d4b19b1113cc189d0f59784876c5b0382a04c6948dd0d0f94aef568585364"

  bottle do
    cellar :any
    sha256 "b6879e8136c7d181e6de51da729265986ed4753251613ac2392a02e9ccf6a794" => :el_capitan
    sha256 "4df3d35d6f9a4587b9f5121d0384abebfc9efe623442842823e54ad917c7d0b0" => :yosemite
    sha256 "c1494e8eaba171cb176b50f24e8702b607bc90b25f90fcbbc6bd37ac785c9eb4" => :mavericks
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
