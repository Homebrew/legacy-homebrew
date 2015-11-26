class OpenSceneGraph < Formula
  desc "3D graphics toolkit"
  homepage "http://www.openscenegraph.org/projects/osg"
  url "http://trac.openscenegraph.org/downloads/developer_releases/OpenSceneGraph-3.4.0.zip"
  sha256 "5c727d84755da276adf8c4a4a3a8ba9c9570fc4b4969f06f1d2e9f89b1e3040e"

  head "https://github.com/openscenegraph/osg.git"

  bottle do
    sha256 "d24a9ba62fdd3d700e8c326e0ac8786229a4d84ca9786fac58b1ff8d785148ff" => :yosemite
    sha256 "a2bb83a0e02b1f5a75e802053cba6c81b6928c716fb805caf7d53becc9e0ee8e" => :mavericks
    sha256 "86e946339bf8293c784e4ceb78b2ff5f203bf7166427d2e66abb462d6f03e406" => :mountain_lion
  end

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

  needs :cxx11

  # patch necessary to ensure support for gtkglext-quartz
  # filed as an issue to the developers https://github.com/openscenegraph/osg/issues/34
  patch :DATA

  if build.with? "docs"
    depends_on "doxygen" => :build
    depends_on "graphviz" => :build
  end

  def install
    ENV.cxx11

    # Turning off FFMPEG takes this change or a dozen "-DFFMPEG_" variables
    if build.without? "ffmpeg"
      inreplace "CMakeLists.txt", "FIND_PACKAGE(FFmpeg)", "#FIND_PACKAGE(FFmpeg)"
    end

    args = std_cmake_args
    args << "-DBUILD_DOCUMENTATION=" + ((build.with? "docs") ? "ON" : "OFF")

    # Fixes Xcode 7.1 failure due to warning in system Framework
    # https://github.com/Homebrew/homebrew/issues/46372
    args << "-DCMAKE_CXX_FLAGS=-Wno-c++11-narrowing"

    if MacOS.prefer_64_bit?
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.arch_64_bit}"
      args << "-DOSG_DEFAULT_IMAGE_PLUGIN_FOR_OSX=imageio"
      args << "-DOSG_WINDOWING_SYSTEM=Cocoa"
    else
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.arch_32_bit}"
    end

    if build.with? "collada-dom"
      # https://github.com/Homebrew/homebrew/issues/43536
      collada_include_dir = Dir.glob("#{Formula["collada-dom"].opt_include}/collada-dom*").first
      raise "Could not locate collada-dom include directory" unless collada_include_dir
      args << "-DCOLLADA_INCLUDE_DIR=#{collada_include_dir}"
      args << "-DCOLLADA_DOM_ROOT=#{collada_include_dir}/1.4/dom"
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
diff --git a/src/osgPlugins/dicom/CMakeLists.txt b/src/osgPlugins/dicom/CMakeLists.txt
index 55c2a57..e6e3f4a 100644
--- a/src/osgPlugins/dicom/CMakeLists.txt
+++ b/src/osgPlugins/dicom/CMakeLists.txt
@@ -5,7 +5,7 @@ IF  (DCMTK_FOUND)

     SET(TARGET_SRC ReaderWriterDICOM.cpp )

-    LINK_LIBRARIES(${DCMTK_LIBRARIES} ${ZLIB_LIBRARY})
+    LINK_LIBRARIES(${DCMTK_LIBRARIES} iconv ${ZLIB_LIBRARY})

     ADD_DEFINITIONS(-DUSE_DCMTK)

