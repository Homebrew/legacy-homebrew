require "formula"

class Tippecanoe < Formula
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/v1.1.0.tar.gz"
  sha1 "5b50dc19c1e56ea4051dee5e790dd5cd328df005"

  bottle do
    cellar :any
    sha1 "6fa77446f3ad21f346f25ab42c6bbb83f29e58b4" => :yosemite
    sha1 "ee7a92d3ad37e334eb386a45764b5018467e6f5f" => :mavericks
    sha1 "98ee5c744cdd44a4e85475028bf043f15a9f5e2a" => :mountain_lion
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
    assert_equal "using layer name test", output
  end
end
