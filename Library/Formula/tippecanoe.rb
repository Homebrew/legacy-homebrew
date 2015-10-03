class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/v1.2.0.tar.gz"
  sha256 "237510a1a92a8626407c29c8d8047e73bbb22c1a8af8f9d1b8931d994c8fac2d"

  bottle do
    cellar :any
    sha256 "249c74b9b656aa43b687afd62d202dce1ad308ace3d3d02b60f115d55d17f18f" => :yosemite
    sha256 "6a0663d76c8c3b320dfc0a09dd2ba8d282cab0dbcf227ac86b4ec1af410f13bf" => :mavericks
    sha256 "71c71a42d35fa01a9516bd5731378dbf97087da190207e5a1e8c2222b91a50da" => :mountain_lion
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
