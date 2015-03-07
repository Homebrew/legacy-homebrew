require "formula"

class Mapnik < Formula
  homepage "http://www.mapnik.org/"
  head "https://github.com/mapnik/mapnik.git"
  url "https://s3.amazonaws.com/mapnik/dist/v2.2.0/mapnik-v2.2.0.tar.bz2"
  sha256 "9b30de4e58adc6d5aa8478779d0a47fdabe6bf8b166b67a383b35f5aa5d6c1b0"
  revision 4

  bottle do
    revision 1
    sha256 "87fa6cda55325d6d25c6a784f126168db31b17f2d8a393fcf32437da5a09762d" => :yosemite
    sha256 "d1244a83b9c97afde10dd6a94855d8c4a9a130e611ad5ea8ce6692f0e8982a91" => :mavericks
    sha256 "ff836a670b6991041ca99b776afda125f4b434c6c8d160bd413b7f25125f8fde" => :mountain_lion
  end

  stable do
    # can be removed at Mapnik > 2.2.0
    # https://github.com/mapnik/mapnik/issues/1973
    patch :DATA

    # boost 1.56 compatibility
    # concatenated from https://github.com/mapnik/mapnik/issues/2428
    patch do
      url "https://gist.githubusercontent.com/tdsmith/22aeb0bfb9691de91463/raw/3064c193466a041d82e011dc5601312ccadc9e15/mapnik-boost-megadiff.diff"
      sha1 "63939ad5e197c83f7fe09e321484248dfd96d0f3"
    end
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "proj"
  depends_on "icu4c"
  depends_on "jpeg"
  depends_on "boost"
  depends_on "boost-python"
  depends_on "gdal" => :optional
  depends_on "postgresql" => :optional
  depends_on "cairo" => :optional

  depends_on "py2cairo" if build.with? "cairo"

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

    if build.with? "cairo"
      args << "CAIRO=True" # cairo paths will come from pkg-config
    else
      args << "CAIRO=False"
    end
    args << "GDAL_CONFIG=#{Formula["gdal"].opt_bin}/gdal-config" if build.with? "gdal"
    args << "PG_CONFIG=#{Formula["postgresql"].opt_bin}/pg_config" if build.with? "postgresql"

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
