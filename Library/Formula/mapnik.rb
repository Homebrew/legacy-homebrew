require 'formula'

class Mapnik < Formula
  homepage 'http://www.mapnik.org/'
  url 'http://mapnik.s3.amazonaws.com/dist/v2.2.0/mapnik-v2.2.0.tar.bz2'
  sha1 'e493ad87ca83471374a3b080f760df4b25f7060d'
  revision 1

  # can be removed at Mapnik > 2.2.0
  # https://github.com/mapnik/mapnik/issues/1973
  patch :DATA
  head 'https://github.com/mapnik/mapnik.git'

  depends_on 'pkg-config' => :build
  depends_on 'freetype'
  depends_on 'libpng'
  depends_on 'libtiff'
  depends_on 'proj'
  depends_on 'icu4c'
  depends_on 'jpeg'
  depends_on 'boost' => 'with-python'
  depends_on 'gdal' => :optional
  depends_on 'postgresql' => :optional
  depends_on 'cairo' => :optional

  depends_on 'py2cairo' if build.with? 'cairo'

  def install
    icu = Formula["icu4c"].opt_prefix
    boost = Formula["boost"].opt_prefix
    proj = Formula["proj"].opt_prefix
    jpeg = Formula["jpeg"].opt_prefix
    libpng = Formula["libpng"].opt_prefix
    libtiff = Formula["libtiff"].opt_prefix
    freetype = Formula["freetype"].opt_prefix

    # mapnik compiles can take ~1.5 GB per job for some .cpp files
    # so lets be cautious by limiting to CPUS/2
    jobs = ENV.make_jobs.to_i
    jobs /= 2 if jobs > 2

    args = [ "CC=\"#{ENV.cc}\"",
             "CXX=\"#{ENV.cxx}\"",
             "JOBS=#{jobs}",
             "PREFIX=#{prefix}",
             "ICU_INCLUDES=#{icu}/include",
             "ICU_LIBS=#{icu}/lib",
             "PYTHON_PREFIX=#{prefix}",  # Install to Homebrew's site-packages
             "JPEG_INCLUDES=#{jpeg}/include",
             "JPEG_LIBS=#{jpeg}/lib",
             "PNG_INCLUDES=#{libpng}/include",
             "PNG_LIBS=#{libpng}/lib",
             "TIFF_INCLUDES=#{libtiff}/include",
             "TIFF_LIBS=#{libtiff}/lib",
             "BOOST_INCLUDES=#{boost}/include",
             "BOOST_LIBS=#{boost}/lib",
             "PROJ_INCLUDES=#{proj}/include",
             "PROJ_LIBS=#{proj}/lib",
             "FREETYPE_CONFIG=#{freetype}/bin/freetype-config"
           ]

    if build.with? 'cairo'
      args << "CAIRO=True" # cairo paths will come from pkg-config
    else
      args << "CAIRO=False"
    end
    args << "GDAL_CONFIG=#{Formula["gdal"].opt_bin}/gdal-config" if build.with? 'gdal'
    args << "PG_CONFIG=#{Formula["postgresql"].opt_bin}/pg_config" if build.with? 'postgresql'

    system "python", "scons/scons.py", "configure", *args
    system "python", "scons/scons.py", "install"
  end
end

__END__
diff --git a/bindings/python/mapnik_text_placement.cpp b/bindings/python/mapnik_text_placement.cpp
index 0520132..4897c28 100644
--- a/bindings/python/mapnik_text_placement.cpp
+++ b/bindings/python/mapnik_text_placement.cpp
@@ -194,7 +194,11 @@ struct ListNodeWrap: formatting::list_node, wrapper<formatting::list_node>
     ListNodeWrap(object l) : formatting::list_node(), wrapper<formatting::list_node>()
     {
         stl_input_iterator<formatting::node_ptr> begin(l), end;
-        children_.insert(children_.end(), begin, end);
+        while (begin != end)
+        {
+            children_.push_back(*begin);
+            ++begin;
+        }
     }

     /* TODO: Add constructor taking variable number of arguments.
