require 'formula'

class Bamtools < Formula
  homepage 'https://github.com/pezmaster31/bamtools'
  url 'https://github.com/downloads/pezmaster31/bamtools/bamtools-1.0.2.tar.gz'
  sha1 '70d4a1f8d7da73dd381b609b618ed19b6184366e'

  head 'https://github.com/pezmaster31/bamtools.git'

  depends_on 'cmake' => :build

  # Install libbamtools in /usr/local/lib.
  # Link statically with libbamtools-util and libjsoncpp, since
  # they're not installed by default. Sent upstream:
  # https://github.com/pezmaster31/bamtools/pull/55
  def patches
     DATA
  end

  def install
    mkdir 'default' do
      system "cmake", "..", *std_cmake_args
      system "make install"
    end
  end

  def test
    system "#{bin}/bamtools", "--version"
  end
end

__END__
diff -ur bamtools-1.0.2.orig/src/api/CMakeLists.txt bamtools-1.0.2/src/api/CMakeLists.txt
--- bamtools-1.0.2.orig/src/api/CMakeLists.txt	2011-09-09 18:59:44.000000000 -0700
+++ bamtools-1.0.2/src/api/CMakeLists.txt	2012-06-15 10:46:18.000000000 -0700
@@ -54,8 +54,8 @@
 target_link_libraries( BamTools-static z )

 # set library install destinations
-install( TARGETS BamTools LIBRARY DESTINATION "lib/bamtools" RUNTIME DESTINATION "bin")
-install( TARGETS BamTools-static ARCHIVE DESTINATION "lib/bamtools")
+install( TARGETS BamTools LIBRARY DESTINATION "lib" RUNTIME DESTINATION "bin")
+install( TARGETS BamTools-static ARCHIVE DESTINATION "lib")

 # export API headers
 include(../ExportHeader.cmake)
diff -ur bamtools-1.0.2.orig/src/third_party/jsoncpp/CMakeLists.txt bamtools-1.0.2/src/third_party/jsoncpp/CMakeLists.txt
--- bamtools-1.0.2.orig/src/third_party/jsoncpp/CMakeLists.txt	2012-06-15 10:39:40.000000000 -0700
+++ bamtools-1.0.2/src/third_party/jsoncpp/CMakeLists.txt	2012-06-15 10:41:49.000000000 -0700
@@ -10,7 +10,7 @@
 add_definitions( -fPIC ) # (attempt to force PIC compiling on CentOS, not being set on shared libs by CMake)

 # create jsoncpp library
-add_library ( jsoncpp SHARED
+add_library ( jsoncpp STATIC
               json_reader.cpp
               json_value.cpp
               json_writer.cpp
diff -ur bamtools-1.0.2.orig/src/utils/CMakeLists.txt bamtools-1.0.2/src/utils/CMakeLists.txt
--- bamtools-1.0.2.orig/src/utils/CMakeLists.txt	2012-06-15 10:39:40.000000000 -0700
+++ bamtools-1.0.2/src/utils/CMakeLists.txt	2012-06-15 10:41:34.000000000 -0700
@@ -13,7 +13,7 @@
 add_definitions( -fPIC ) # (attempt to force PIC compiling on CentOS, not being set on shared libs by CMake)

 # create BamTools utils library
-add_library ( BamTools-utils SHARED
+add_library ( BamTools-utils STATIC
               bamtools_fasta.cpp
               bamtools_options.cpp
               bamtools_pileup_engine.cpp
