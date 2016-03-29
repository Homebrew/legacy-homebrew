class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.9.6.tar.gz"
  sha256 "2d84b9431956acff860fe2cec037c23645fea5d141ed1c6980cc87d804750ee0"

  bottle do
    cellar :any
    sha256 "5424b4527e952fff1175b00959f63a6b42e3d9be6bd494329926d9bc6073eba6" => :el_capitan
    sha256 "a060a98b6a328a13e4144c914a684fe5448cd0084d1712bed3498623a5ee4e56" => :yosemite
    sha256 "545659406a517c9c2051070d5dca46ccc344eaa189cf56a1f10571d9751df30c" => :mavericks
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
