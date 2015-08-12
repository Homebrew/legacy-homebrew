class OpenSceneGraph < Formula
  desc "3D graphics toolkit"
  homepage "http://www.openscenegraph.org/projects/osg"
  url "http://trac.openscenegraph.org/downloads/developer_releases/OpenSceneGraph-3.5.1.zip"
  sha256 "c409e9095d77faab3db8fe2047d75e7ef348fd9f06ecd8b7629fceb8fe1d24e0"

  head "http://www.openscenegraph.org/svn/osg/OpenSceneGraph/trunk/"

  bottle do
    sha256 "d75dbe609dc34b520dd70a8a04548252e3cb68e9faa28221420ceb7e5e56f2cf" => :mavericks
  end

  option :cxx11
  option "with-docs", "Build the documentation with Doxygen and Graphviz"
  deprecated_option "docs" => "with-docs"

  # Currently does not build on 10.10+, possibly due to Xcode 7 issue
  # https://github.com/Homebrew/homebrew/pull/46776
  depends_on MaximumMacOSRequirement => :mavericks

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
    args << "-DCMAKE_CXX_FLAGS='-Wno-c++11-narrowing'"

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
--- a/include/osgViewer/View	2015-11-26 11:37:57.000000000 +0100
+++ b/include/osgViewer/View	2015-11-26 11:38:53.000000000 +0100
@@ -127,7 +127,7 @@
         /** Set the View's image pager.*/
         void setImagePager(osgDB::ImagePager* ip);
 
-        template<class T> void setImagePager(const osg::ref_ptr<T>* ip) { setImagePager(ip.get()); }
+        template<class T> void setImagePager(const osg::ref_ptr<T>& ip) { setImagePager(ip.get()); }
 
         /** Get the View's image pager.*/
         osgDB::ImagePager* getImagePager();
--- a/include/osgUtil/IntersectionVisitor	2015-11-28 02:42:23.000000000 +0100
+++ b/include/osgUtil/IntersectionVisitor	2015-11-28 02:41:59.000000000 +0100
@@ -160,7 +160,7 @@
           * tighter integration.*/
         struct ReadCallback : public osg::Referenced
         {
-            virtual osg::ref_ptr<osg::Node> readNodeFile(const std::string& filename) = 0;
+            virtual osg::Node* readNodeFile(const std::string& filename) = 0;
         };
 
 
--- a/include/osgSim/LineOfSight	2015-11-28 02:44:57.000000000 +0100
+++ a/include/osgSim/LineOfSight	2015-11-28 02:44:51.000000000 +0100
@@ -32,7 +32,7 @@
 
         void pruneUnusedDatabaseCache();
 
-        virtual osg::ref_ptr<osg::Node> readNodeFile(const std::string& filename);
+        virtual osg::Node* readNodeFile(const std::string& filename);
 
     protected:
 
--- a/src/osgSim/LineOfSight.cpp	2015-11-28 04:00:38.000000000 +0100
+++ a/src/osgSim/LineOfSight.cpp	2015-11-28 04:00:35.000000000 +0100
@@ -34,7 +34,7 @@
 {
 }
 
-osg::ref_ptr<osg::Node> DatabaseCacheReadCallback::readNodeFile(const std::string& filename)
+osg::Node* DatabaseCacheReadCallback::readNodeFile(const std::string& filename)
 {
     // first check to see if file is already loaded.
     {
