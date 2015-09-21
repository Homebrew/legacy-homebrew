class Cgal < Formula
  desc "CGAL: Computational Geometry Algorithm Library"
  homepage "http://www.cgal.org/"
  url "https://gforge.inria.fr/frs/download.php/file/35009/CGAL-4.6.2.tar.gz"
  sha256 "9dc88cd6a2d0f77120ca1f0a88cf83408b7763eaec9948de1fee228ea0ed31d7"

  bottle do
    cellar :any
    sha256 "32eea5b3030bc61a7a5e8143694320dd478b1fc6fb8e285c38bc9ae8a3ce0bad" => :el_capitan
    sha256 "a729d74f92920f5d19850187bd026707ce435df5137968da32bfba88fb24f38e" => :yosemite
    sha256 "ab7d1c685f33fae339d11d0c9d71aacd43835f2fb61778aa86776bafdb0b4560" => :mavericks
    sha256 "83c449caa96e82718aeaf3bf7e17b62b964bb21c64109bd9368645159413db8b" => :mountain_lion
  end

  option :cxx11

  option "imaging", "Build ImageIO and QT compoments of CGAL"
  option "with-eigen3", "Build with Eigen3 support"
  option "with-lapack", "Build with LAPACK support"

  depends_on "cmake" => :build
  if build.cxx11?
    depends_on "boost" => "c++11"
    depends_on "gmp"   => "c++11"
  else
    depends_on "boost"
    depends_on "gmp"
  end
  depends_on "mpfr"

  depends_on "qt" if build.include? "imaging"
  depends_on "eigen" if build.with? "eigen3"

  # Allows to compile with clang 425: http://goo.gl/y9Dg2y
  patch :DATA

  def install
    ENV.cxx11 if build.cxx11?
    args = ["-DCMAKE_INSTALL_PREFIX=#{prefix}",
            "-DCMAKE_BUILD_TYPE=Release",
            "-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON",
            "-DCMAKE_INSTALL_NAME_DIR=#{HOMEBREW_PREFIX}/lib"]
    unless build.include? "imaging"
      args << "-DWITH_CGAL_Qt3=OFF" << "-DWITH_CGAL_Qt4=OFF" << "-DWITH_CGAL_ImageIO=OFF"
    end
    if build.with? "eigen3"
      args << "-DWITH_Eigen3=ON"
    end
    if build.with? "lapack"
      args << "-DWITH_LAPACK=ON"
    end
    args << "."
    system "cmake", *args
    system "make", "install"
  end
end

__END__
diff --git a/src/CGAL/File_header_extended_OFF.cpp b/src/CGAL/File_header_extended_OFF.cpp
index 3f709ff..f0e5bd3 100644
--- a/src/CGAL/File_header_extended_OFF.cpp
+++ b/src/CGAL/File_header_extended_OFF.cpp
@@ -186,7 +186,8 @@ std::istream& operator>>( std::istream& in, File_header_extended_OFF& h) {
         }
         in >> keyword;
     }
-    in >> skip_until_EOL >> skip_comment_OFF;
+    skip_until_EOL(in);
+    skip_comment_OFF(in);
     return in;
 }
 #undef CGAL_IN
