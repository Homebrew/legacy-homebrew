require 'formula'

class Mapnik < Formula
  homepage 'http://www.mapnik.org/'
  url 'https://github.com/downloads/mapnik/mapnik/mapnik-v2.1.0.tar.bz2'
  sha1 'b1c6a138e65a5e20f0f312a559e2ae7185adf5b6'

  # batch for building against boost >1.52
  # can be removed at Mapnik >= 2.1.1
  # https://github.com/mapnik/mapnik/issues/1716
  def patches
    DATA
  end

  head 'https://github.com/mapnik/mapnik.git'

  depends_on 'pkg-config' => :build
  depends_on :libtool
  depends_on :freetype
  depends_on :libpng
  depends_on 'libtiff'
  depends_on 'proj'
  depends_on 'icu4c'
  depends_on 'jpeg'
  depends_on 'boost'
  depends_on 'gdal' => :optional
  depends_on 'geos' => :optional
  depends_on 'cairo' => :optional

  if build.with? 'cairo'
    depends_on 'py2cairo'
    depends_on 'cairomm'
  end

  def install
    icu = Formula.factory("icu4c").opt_prefix
    boost = Formula.factory('boost').opt_prefix
    proj = Formula.factory('proj').opt_prefix
    jpeg = Formula.factory('jpeg').opt_prefix
    libtiff = Formula.factory('libtiff').opt_prefix
    cairo = Formula.factory('cairo').opt_prefix if build.with? 'cairo'

    # mapnik compiles can take ~1.5 GB per job for some .cpp files
    # so lets be cautious by limiting to CPUS/2
    jobs = ENV.make_jobs.to_i
    jobs /= 2 if jobs > 2

    args = [ "scons/scons.py",
             "configure",
             "CC=\"#{ENV.cc}\"",
             "CXX=\"#{ENV.cxx}\"",
             "JOBS=#{jobs}",
             "PREFIX=#{prefix}",
             "ICU_INCLUDES=#{icu}/include",
             "ICU_LIBS=#{icu}/lib",
             "PYTHON_PREFIX=#{prefix}",  # Install to Homebrew's site-packages
             "JPEG_INCLUDES=#{jpeg}/include",
             "JPEG_LIBS=#{jpeg}/lib",
             "TIFF_INCLUDES=#{libtiff}/include",
             "TIFF_LIBS=#{libtiff}/lib",
             "BOOST_INCLUDES=#{boost}/include",
             "BOOST_LIBS=#{boost}/lib",
             "PROJ_INCLUDES=#{proj}/include",
             "PROJ_LIBS=#{proj}/lib" ]

    if build.with? 'cairo'
      args << "CAIRO=True" # cairo paths will come from pkg-config
    else
      args << "CAIRO=False"
    end
    args << "GEOS_CONFIG=#{Formula.factory('geos').opt_prefix}/bin/geos-config" if build.with? 'geos'
    args << "GDAL_CONFIG=#{Formula.factory('gdal').opt_prefix}/bin/gdal-config" if build.with? 'gdal'

    system "python", *args

    system "python",
           "scons/scons.py",
           "install"
  end

  def caveats; <<-EOS.undent
    For non-homebrew Python, you need to amend your PYTHONPATH like so:
      export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/#{which_python}/site-packages:$PYTHONPATH
    EOS
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end
end

__END__
diff --git a/src/json/feature_collection_parser.cpp b/src/json/feature_collection_parser.cpp
index 3faeda7..51ad824 100644
--- a/src/json/feature_collection_parser.cpp
+++ b/src/json/feature_collection_parser.cpp
@@ -20,12 +20,17 @@
  *
  *****************************************************************************/

+// TODO https://github.com/mapnik/mapnik/issues/1658
+#include <boost/version.hpp>
+#if BOOST_VERSION >= 105200
+#define BOOST_SPIRIT_USE_PHOENIX_V3
+#endif
+
 // mapnik
 #include <mapnik/json/feature_collection_parser.hpp>
 #include <mapnik/json/feature_collection_grammar.hpp>

 // boost
-#include <boost/version.hpp>
 #include <boost/spirit/include/qi.hpp>
 #include <boost/spirit/include/support_multi_pass.hpp>
