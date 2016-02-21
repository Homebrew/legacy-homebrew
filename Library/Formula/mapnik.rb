class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "http://www.mapnik.org/"
  url "https://github.com/mapnik/mapnik/archive/v3.0.9.tar.gz"
  sha256 "f0242606096e2c4ca2cd0caac1ff0fd5f8054a38b5f288ba38b0e397b5b311b2"

  head "https://github.com/mapnik/mapnik.git"

  bottle do
    cellar :any
    sha256 "2b94d65405e6f95c3b327f9e1f7e1b7ded382ec4d8ccf63b4832aa9c0a69d707" => :el_capitan
    sha256 "1269bd66b40b6a5a01ba08d22be929e7e55000467376cee08a20c7cd27d22ab0" => :yosemite
    sha256 "b43933b817c912adeb2e213dc255637dfd012ed64530c91903b4095fef3ef43a" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "harfbuzz"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "proj"
  depends_on "icu4c"
  depends_on "jpeg"
  depends_on "webp"
  depends_on "gdal" => :optional
  depends_on "postgresql" => :optional
  depends_on "cairo" => :optional

  if MacOS.version < :mavericks
    depends_on "boost" => "c++11"
  else
    depends_on "boost"
  end

  needs :cxx11

  def install
    ENV.cxx11
    icu = Formula["icu4c"].opt_prefix
    boost = Formula["boost"].opt_prefix
    proj = Formula["proj"].opt_prefix
    jpeg = Formula["jpeg"].opt_prefix
    libpng = Formula["libpng"].opt_prefix
    libtiff = Formula["libtiff"].opt_prefix
    freetype = Formula["freetype"].opt_prefix
    harfbuzz = Formula["harfbuzz"].opt_prefix
    webp = Formula["webp"].opt_prefix

    args = ["CC=\"#{ENV.cc}\"",
            "CXX=\"#{ENV.cxx}\"",
            "PREFIX=#{prefix}",
            "CUSTOM_CXXFLAGS=\"-DBOOST_EXCEPTION_DISABLE\"",
            "ICU_INCLUDES=#{icu}/include",
            "ICU_LIBS=#{icu}/lib",
            "JPEG_INCLUDES=#{jpeg}/include",
            "JPEG_LIBS=#{jpeg}/lib",
            "PNG_INCLUDES=#{libpng}/include",
            "PNG_LIBS=#{libpng}/lib",
            "HB_INCLUDES=#{harfbuzz}/include",
            "HB_LIBS=#{harfbuzz}/lib",
            "WEBP_INCLUDES=#{webp}/include",
            "WEBP_LIBS=#{webp}/lib",
            "TIFF_INCLUDES=#{libtiff}/include",
            "TIFF_LIBS=#{libtiff}/lib",
            "BOOST_INCLUDES=#{boost}/include",
            "BOOST_LIBS=#{boost}/lib",
            "PROJ_INCLUDES=#{proj}/include",
            "PROJ_LIBS=#{proj}/lib",
            "FREETYPE_CONFIG=#{freetype}/bin/freetype-config",
            "NIK2IMG=False",
            "CPP_TESTS=False", # too long to compile to be worth it
            "INPUT_PLUGINS=all",
           ]

    if build.with? "cairo"
      args << "CAIRO=True" # cairo paths will come from pkg-config
    else
      args << "CAIRO=False"
    end
    args << "GDAL_CONFIG=#{Formula["gdal"].opt_bin}/gdal-config" if build.with? "gdal"
    args << "PG_CONFIG=#{Formula["postgresql"].opt_bin}/pg_config" if build.with? "postgresql"

    system "./configure", *args
    system "make"
    system "make", "install"
  end
end
