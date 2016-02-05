class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https://launchpad.net/mydumper"
  url "https://launchpad.net/mydumper/0.9/0.9.1/+download/mydumper-0.9.1.tar.gz"
  sha256 "aefab5dc4192acb043d685b6bb952c87557fbea5e083b8547c68ccfec878171f"

  bottle do
    cellar :any
    sha256 "8dcd810f09fe2e8acaa447db3ed5557c7f15d49cb1f448b366d2bd9ab0bc13a1" => :el_capitan
    sha256 "884224a200374ef892c40f844ef4f85bc33345a1ccd7387575deac52d2de8387" => :yosemite
    sha256 "a2faa115d33c1029d49eb1dd684bc52b069d9df9bc6efb59bd21bd50cd8a4491" => :mavericks
  end

  option "without-docs", "Don't build man pages"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build if build.with? "docs"
  depends_on "glib"
  depends_on "mysql"
  depends_on "pcre"
  depends_on "openssl"

  # This patch allows cmake to find .dylib shared libs in OS X. A bug report has
  # been filed upstream here: https://bugs.launchpad.net/mydumper/+bug/1517966
  # It also ignores .a libs because of an issue with glib's static libraries now
  # being included by default in homebrew.
  patch :p0, :DATA

  def install
    args = std_cmake_args

    if build.without? "docs"
      args << "-DBUILD_DOCS=OFF"
    end

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system bin/"mydumper", "--help"
  end
end

__END__
--- cmake/modules/FindMySQL.cmake	2015-09-16 16:11:34.000000000 -0400
+++ cmake/modules/FindMySQL.cmake	2015-09-16 16:10:56.000000000 -0400
@@ -84,7 +84,7 @@
 )

 set(TMP_MYSQL_LIBRARIES "")
-set(CMAKE_FIND_LIBRARY_SUFFIXES .so .a .lib)
+set(CMAKE_FIND_LIBRARY_SUFFIXES .so .lib .dylib)
 foreach(MY_LIB ${MYSQL_ADD_LIBRARIES})
     find_library("MYSQL_LIBRARIES_${MY_LIB}" NAMES ${MY_LIB}
         HINTS
