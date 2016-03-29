class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.9.6.tar.gz"
  sha256 "2d84b9431956acff860fe2cec037c23645fea5d141ed1c6980cc87d804750ee0"

  bottle do
    cellar :any
    sha256 "803aa53b505ee70322b7f475f69fa20bc0ccbde23cef11e66531f97d510446b0" => :el_capitan
    sha256 "a53449ece9866b704dd2eab02323d17cb7fdfa2a6403c4c51294fd1fed183bb6" => :yosemite
    sha256 "79da2d22f7501bf0d6243e55ab95c4c2d88df40c7316db024c2821145a7c982a" => :mavericks
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
