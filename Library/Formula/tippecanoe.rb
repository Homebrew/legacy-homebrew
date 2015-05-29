require "formula"

class Tippecanoe < Formula
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/v1.2.0.tar.gz"
  sha1 "348563c57629260d17e1761f9aedd85b1a0453ba"

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
