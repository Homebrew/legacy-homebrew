require "formula"

class Orthanc < Formula
  homepage "http://www.orthanc-server.com/"
  url "https://github.com/jodogne/Orthanc/releases/download/0.7.3/Orthanc-0.7.3.tar.gz"
  sha1 "30176fe2c4f9917a4f7230dbe5dda59572a4487e"

  depends_on "cmake" => :build
  depends_on "glog"
  depends_on "boost"
  depends_on "dcmtk"
  depends_on "lua"
  depends_on "libpng"

  def patches
    # The git checkout on the homebrew test server strips <CR><LF>, therefore to get the patch
    # to apply cleanly, we must strip them from the file to be patched too.
    if @buildpath then
      inreplace 'CMakeLists.txt' do |s|
        s.gsub! /\r\n/, "\n"
      end
    end
    # This patch fixes build & code issues directly related to running on Mac OS X.
    # Until this is merged back into Orthanc this is required to build for Mac.
    DATA
  end

  resource "gtest" do
    url 'http://www.montefiore.ulg.ac.be/~jodogne/Orthanc/ThirdPartyDownloads/gtest-1.6.0.zip'
    sha1 '00d6be170eb9fc3b2198ffdcb1f1d6ba7fc6e621'
  end

  resource "mongoose" do
    url 'http://www.montefiore.ulg.ac.be/~jodogne/Orthanc/ThirdPartyDownloads/mongoose-3.1.tgz'
    sha1 'c367932b5faa7c86b70bf8f0351792a0bcc68c03'
  end

  def install
    Pathname.new('ThirdPartyDownloads').mkpath
    cd 'ThirdPartyDownloads' do
      resource("mongoose").fetch.cp "mongoose-3.1.tgz"
      resource("gtest").fetch.cp "gtest-1.6.0.zip"
    end

    system "cmake", ".",  "-DUSE_SYSTEM_MONGOOSE=OFF",
                          "-DUSE_SYSTEM_GOOGLE_TEST=NO",
                          "-DCMAKE_INCLUDE_PATH=#{HOMEBREW_PREFIX}/include",
                          "-DCMAKE_LIBRARY_PATH=#{HOMEBREW_PREFIX}/lib",
                          "-DDCMTK_DIR=#{HOMEBREW_PREFIX}/include/dcmtk",
                          "-DDCMTK_DICTIONARY_DIR=#{HOMEBREW_PREFIX}/share/dcmtk",
                          "-DDCMTK_LIBRARIES=oflog;iconv",
                          "-DHAVE_JSONCPP_H=#{HOMEBREW_PREFIX}/json/reader.h",
                          *std_cmake_args

    system "make", "install"

  end

  test do
    system "#{bin}/Orthanc"
  end
end

__END__
diff -ur Orthanc-0.7.3/CMakeLists.txt Orthanc-0.7.3-C/CMakeLists.txt
--- Orthanc-0.7.3/CMakeLists.txt	2014-03-05 11:04:17.000000000 +0000
+++ Orthanc-0.7.3-C/CMakeLists.txt	2014-03-05 10:52:28.000000000 +0000
@@ -248,7 +248,7 @@
   add_definitions(-DUNIT_TESTS_WITH_HTTP_CONNEXIONS=0)
 endif()
 
-add_definitions(-DORTHANC_BUILD_UNIT_TESTS=1)
+add_definitions(-DORTHANC_BUILD_UNIT_TESTS=1 -DGTEST_USE_OWN_TR1_TUPLE=1)
 include(${CMAKE_SOURCE_DIR}/Resources/CMake/GoogleTestConfiguration.cmake)
 add_executable(UnitTests
   ${GTEST_SOURCES}
@@ -338,6 +338,13 @@
       )
     target_link_libraries(OrthancClient pthread)
 
+  elseif (${CMAKE_SYSTEM_NAME} STREQUAL "Darwin")
+	set_target_properties(OrthancClient
+		PROPERTIES LINK_FLAGS "${CMAKE_SHARED_LINKER_FLAGS}"
+	)
+	target_link_libraries(OrthancClient pthread)
+
+
   elseif (${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
     target_link_libraries(OrthancClient OpenSSL ws2_32)
 
diff -ur Orthanc-0.7.3/Core/Toolbox.cpp Orthanc-0.7.3-C/Core/Toolbox.cpp
--- Orthanc-0.7.3/Core/Toolbox.cpp	2014-02-14 11:06:31.000000000 +0000
+++ Orthanc-0.7.3-C/Core/Toolbox.cpp	2014-03-04 18:13:09.000000000 +0000
@@ -161,7 +161,7 @@
   {
 #if defined(_WIN32)
     ::Sleep(static_cast<DWORD>(microSeconds / static_cast<uint64_t>(1000)));
-#elif defined(__linux)
+#elif defined(__linux) || (defined(__APPLE__) && defined(__MACH__))
     usleep(microSeconds);
 #else
 #error Support your platform here
diff -ur Orthanc-0.7.3/OrthancServer/DicomProtocol/DicomServer.cpp Orthanc-0.7.3-C/OrthancServer/DicomProtocol/DicomServer.cpp
--- Orthanc-0.7.3/OrthancServer/DicomProtocol/DicomServer.cpp	2014-02-14 11:06:31.000000000 +0000
+++ Orthanc-0.7.3-C/OrthancServer/DicomProtocol/DicomServer.cpp	2014-03-04 18:13:51.000000000 +0000
@@ -115,7 +115,7 @@
     LoadEmbeddedDictionary(d, EmbeddedResources::DICTIONARY_DICOM);
     LoadEmbeddedDictionary(d, EmbeddedResources::DICTIONARY_PRIVATE);
 
-#elif defined(__linux)
+#elif defined(__linux) || (defined(__APPLE__) && defined(__MACH__))
     std::string path = DCMTK_DICTIONARY_DIR;
 
     const char* env = std::getenv(DCM_DICT_ENVIRONMENT_VARIABLE);
diff -ur Orthanc-0.7.3/OrthancServer/DicomProtocol/DicomUserConnection.cpp Orthanc-0.7.3-C/OrthancServer/DicomProtocol/DicomUserConnection.cpp
--- Orthanc-0.7.3/OrthancServer/DicomProtocol/DicomUserConnection.cpp	2014-02-14 11:06:31.000000000 +0000
+++ Orthanc-0.7.3-C/OrthancServer/DicomProtocol/DicomUserConnection.cpp	2014-03-04 18:18:01.000000000 +0000
@@ -57,6 +57,10 @@
 #define HOST_NAME_MAX 256
 #endif 
 
+#ifdef __APPLE__
+#define HOST_NAME_MAX 255
+#endif
+
 
 static const char* DEFAULT_PREFERRED_TRANSFER_SYNTAX = UID_LittleEndianImplicitTransferSyntax;
 
diff -ur Orthanc-0.7.3/OrthancServer/Internals/StoreScp.cpp Orthanc-0.7.3-C/OrthancServer/Internals/StoreScp.cpp
--- Orthanc-0.7.3/OrthancServer/Internals/StoreScp.cpp	2014-02-14 11:06:31.000000000 +0000
+++ Orthanc-0.7.3-C/OrthancServer/Internals/StoreScp.cpp	2014-03-04 18:46:50.000000000 +0000
@@ -130,7 +130,7 @@
 
           // check the image to make sure it is consistent, i.e. that its sopClass and sopInstance correspond
           // to those mentioned in the request. If not, set the status in the response message variable.
-          if ((rsp->DimseStatus == STATUS_Success))
+          if (rsp->DimseStatus == STATUS_Success)
           {
             // which SOP class and SOP instance ?
             if (!DU_findSOPClassAndInstanceInDataSet(*imageDataSet, sopClass, sopInstance, /*opt_correctUIDPadding*/ OFFalse))
--- Orthanc-0.7.3/UnitTestsSources/main.cpp	2014-02-14 11:06:31.000000000 +0000
+++ Orthanc-0.7.3-C/UnitTestsSources/main.cpp	2014-03-04 20:10:23.000000000 +0000
@@ -621,7 +621,7 @@
   // Parts of this test come from Adam Conrad
   // http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=728822#5
 
-#if defined(_WIN32)
+#if defined(_WIN32) || defined(__APPLE__)
   ASSERT_EQ(Endianness_Little, Toolbox::DetectEndianness());
 
 #elif defined(__linux)
