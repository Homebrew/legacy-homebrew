class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "http://www.mapnik.org/"
  head "https://github.com/mapnik/mapnik.git"
  url "https://s3.amazonaws.com/mapnik/dist/v3.0.5/mapnik-v3.0.5.tar.bz2"
  sha256 "d8f771d45b236d987aab44819a517f4c1ed6d7ff2c42c2e51160e37d28c89cc3"

  bottle do
    cellar :any
    sha256 "ba96b1394a1949a96dedd2db67a4cf60a23238b80c130a1d980968e56c83c134" => :el_capitan
    sha256 "1ce438112b93ccfe5bb117dffb32dc3f06b7d58636a1e03edcb7291e30d14fac" => :yosemite
    sha256 "4143fcb493a169569b6317337dc26c35be03dd8713aba78b080ff5e5dbec4a37" => :mavericks
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
            "INPUT_PLUGINS=all"
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
