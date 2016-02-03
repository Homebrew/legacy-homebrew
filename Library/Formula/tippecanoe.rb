class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.6.4.tar.gz"
  sha256 "a95e7f054671b24c0a8ac61b40a1cc379f58e9a4273172671409631e136da9d3"

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
    path = testpath/"test.json"
    path.write <<-EOS.undent
      {"type":"Feature","properties":{},"geometry":{"type":"Point","coordinates":[0,0]}}
    EOS
    output = `#{bin}/tippecanoe -o test.mbtiles #{path}`.strip
    assert_equal 0, $?.exitstatus
    assert_equal "using layer 0 name test", output
  end
end
