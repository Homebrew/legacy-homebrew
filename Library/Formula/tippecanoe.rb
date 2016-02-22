class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/v1.8.1.tar.gz"
  sha256 "f75c48a61a0517675a52bb9b152d33c742b5df1d774734d9c216299788cb2a6f"

  bottle do
    cellar :any
    sha256 "04fc2c6023b7c6341c5bdd7a344772440cff44777b3b492286264fcc365f1260" => :el_capitan
    sha256 "d6ecad260f7cbcef6947cce4066e8c535bed613def4ad4bab57cdcb3f2dad8fd" => :yosemite
    sha256 "58f5c5747867c58e648efaa585ef92294c8bbc18fafaa93de70ab4cf291d8e49" => :mavericks
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
