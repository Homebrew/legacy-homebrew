require "formula"

class Tippecanoe < Formula
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/v1.0.2.tar.gz"
  sha1 "c7804c835a212a04573b94cc084bbae41e23d928"

  bottle do
    cellar :any
    sha1 "deac5778d837d4fa0b89decacafbaf59fcfeabbb" => :yosemite
    sha1 "911bac4f9ff553686b657004527d62f95b626c5d" => :mavericks
    sha1 "5513d9d1ba3cc55061f094cf0dff8ee0430fddea" => :mountain_lion
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
    assert_equal "bbox: 80000000 80000000 80000000 80000000\nusing layer name test", output
  end
end
