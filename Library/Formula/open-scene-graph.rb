class OpenSceneGraph < Formula
  desc "3D graphics toolkit"
  homepage "http://www.openscenegraph.org/projects/osg"
  url "http://trac.openscenegraph.org/downloads/developer_releases/OpenSceneGraph-3.3.3.zip"
  sha256 "b81cda123ffb3bd108e0fe4be4fff1351d6636e6fb0a1475b2c4fb9618d3ae2b"
  revision 1

  bottle do
    sha1 "2f7f0292cf0d66cc37f94ff9d769c7d397e4a19c" => :yosemite
    sha1 "eb231106f731af9f9803e38a2aa152276d99bb79" => :mavericks
    sha1 "f613127ed57c7fba5a8de44f65ea49501c9b1d83" => :mountain_lion
  end

  head "http://www.openscenegraph.org/svn/osg/OpenSceneGraph/trunk/"

  option :cxx11
  option "with-docs", "Build the documentation with Doxygen and Graphviz"
  deprecated_option "docs" => "with-docs"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "wget"
  depends_on "gtkglext"
  depends_on "freetype"
  depends_on "gdal" => :optional
  depends_on "jasper" => :optional
  depends_on "openexr" => :optional
  depends_on "dcmtk" => :optional
  depends_on "librsvg" => :optional
  depends_on "collada-dom" => :optional
  depends_on "gnuplot" => :optional
  depends_on "ffmpeg" => :optional
  depends_on "qt5" => :optional
  depends_on "qt" => :optional

  # patch necessary to ensure support for gtkglext-quartz
  # filed as an issue to the developers https://github.com/openscenegraph/osg/issues/34
  patch :DATA

  if build.with? "docs"
    depends_on "doxygen" => :build
    depends_on "graphviz" => :build
  end

  def install
    ENV.cxx11 if build.cxx11?

    # Turning off FFMPEG takes this change or a dozen "-DFFMPEG_" variables
    if build.without? "ffmpeg"
      inreplace "CMakeLists.txt", "FIND_PACKAGE(FFmpeg)", "#FIND_PACKAGE(FFmpeg)"
    end

    args = std_cmake_args
    args << "-DBUILD_DOCUMENTATION=" + ((build.with? "docs") ? "ON" : "OFF")

    if MacOS.prefer_64_bit?
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.arch_64_bit}"
      args << "-DOSG_DEFAULT_IMAGE_PLUGIN_FOR_OSX=imageio"
      args << "-DOSG_WINDOWING_SYSTEM=Cocoa"
    else
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.arch_32_bit}"
    end

    if build.with? "collada-dom"
      args << "-DCOLLADA_INCLUDE_DIR=#{Formula["collada-dom"].opt_include}/collada-dom"
    end

    if build.with? "qt5"
      args << "-DCMAKE_PREFIX_PATH=#{Formula["qt5"].opt_prefix}"
    elsif build.with? "qt"
      args << "-DCMAKE_PREFIX_PATH=#{Formula["qt"].opt_prefix}"
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "doc_openscenegraph" if build.with? "docs"
      system "make", "install"
      doc.install Dir["#{prefix}/doc/OpenSceneGraphReferenceDocs/*"] if build.with? "docs"
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <iostream>
      #include <osg/Version>
      using namespace std;
      int main()
        {
          cout << osgGetVersion() << endl;
          return 0;
        }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-losg", "-o", "test"
    assert_equal `./test`.chomp, version.to_s
  end
end
__END__
diff --git a/CMakeModules/FindGtkGl.cmake b/CMakeModules/FindGtkGl.cmake
index 321cede..6497589 100644
--- a/CMakeModules/FindGtkGl.cmake
+++ b/CMakeModules/FindGtkGl.cmake
@@ -10,7 +10,7 @@ IF(PKG_CONFIG_FOUND)
     IF(WIN32)
         PKG_CHECK_MODULES(GTKGL gtkglext-win32-1.0)
     ELSE()
-        PKG_CHECK_MODULES(GTKGL gtkglext-x11-1.0)
+        PKG_CHECK_MODULES(GTKGL gtkglext-quartz-1.0)
     ENDIF()

 ENDIF()
