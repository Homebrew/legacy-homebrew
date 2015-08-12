class Mapserver < Formula
  desc "Publish spatial data and interactive mapping apps to the web"
  homepage "http://mapserver.org/"
  url "http://download.osgeo.org/mapserver/mapserver-7.0.0.tar.gz"
  sha256 "b306b8111e0718a577ce595640c2d3224f913745af732a1b75f6f5cb3dddce45"

  bottle do
    cellar :any
    sha256 "8bfa96a50ee83117bd929afc4ed1c6ce3e9e82a7e6da6328e4ca500c4fbb096d" => :yosemite
    sha256 "7ed6da72cbb724c1dfe92cc701bf292ddac02788dc7976f7a81e5e367b472262" => :mavericks
    sha256 "28b3fbf520436359a81d6b0a6875c30cb6f8bdb147ebc14f5860f7cf2c61ad47" => :mountain_lion
  end

  option "with-fastcgi", "Build with fastcgi support"
  option "with-geos", "Build support for GEOS spatial operations"
  option "with-php", "Build PHP MapScript module"
  option "with-postgresql", "Build support for PostgreSQL as a data source"

  env :userpaths

  depends_on "freetype"
  depends_on "libpng"
  depends_on "cmake" => :build
  depends_on "giflib"
  depends_on "gd"
  depends_on "proj"
  depends_on "gdal"
  depends_on "geos" => :optional
  depends_on "postgresql" => :optional unless MacOS.version >= :lion
  depends_on "fcgi" if build.with? "fastcgi"
  depends_on "cairo" => :optional
  depends_on "postgis"

  def install
    args = std_cmake_args
    args += [
      "-DWITH_FRIBIDI=0",
      "-DWITH_HARFBUZZ=0",
    ]

    args << "-DWITH_GEOS=" + ((build.with? "geos") ? "1" : "0")
    args << "-DWITH_CAIRO=" + ((build.with? "cairo") ? "1" : "0")
    args << "-DWITH_FCGI=" + ((build.with? "fcgi") ? "1" : "0")
    args << "-DWITH_PHP=" + ((build.with? "php") ? "1" : "0")

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/mapserv", "-v"
  end
end
