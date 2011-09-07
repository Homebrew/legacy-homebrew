require 'formula'

class Mapnik < Formula
  url 'http://download.berlios.de/mapnik/mapnik-0.7.1.tar.gz'
  homepage 'http://www.mapnik.org/'
  md5 '3a070fdd7c6a3367ad78d95c2387b03b'

  depends_on 'pkg-config' => :build
  depends_on 'scons' => :build
  depends_on 'libtiff'
  depends_on 'jpeg'
  depends_on 'proj'
  depends_on 'icu4c'
  depends_on 'boost'
  depends_on 'cairomm' => :optional

  def install
    ENV.x11 # for freetype-config

    # Allow compilation against boost 1.46
    inreplace ["src/datasource_cache.cpp", "src/libxml2_loader.cpp", "src/load_map.cpp", "src/tiff_reader.cpp"],
      "#include <boost/filesystem/operations.hpp>",
      "#define BOOST_FILESYSTEM_VERSION 2\n#include <boost/filesystem/operations.hpp>"

    icu = Formula.factory("icu4c")
    system "scons",
        "PREFIX=#{prefix}",
        "ICU_INCLUDES=#{icu.include}", "ICU_LIBS=#{icu.lib}",
        "install"
  end
end
