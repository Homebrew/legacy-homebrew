require "formula"

class Tippecanoe < Formula
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/v1.0.2.tar.gz"
  sha1 "c7804c835a212a04573b94cc084bbae41e23d928"

  depends_on "protobuf-c"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    path = testpath/"test.geojson"
    outputPath = testpath/"test.mbtiles"
    path.write <<-EOS
      {"type":"Feature","properties":{},"geometry":{"type":"Point","coordinates":[0,0]}}
    EOS
    puts "#{bin}/tippecanoe #{path} -o #{outputPath}"
    output = `#{bin}/tippecanoe < #{path} -o #{outputPath}`.strip
    assert_equal "bbox: 80000000 80000000 80000000 80000000\nusing layer name test", output
    assert_equal 0, $?.exitstatus
  end
end
