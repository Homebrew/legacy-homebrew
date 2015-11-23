class Cgal < Formula
  desc "CGAL: Computational Geometry Algorithm Library"
  homepage "http://www.cgal.org/"
  url "https://gforge.inria.fr/frs/download.php/file/35138/CGAL-4.6.3.tar.gz"
  sha256 "f90fc9d319a0bdb66b09570a8a0399671c25caeb5db1dc8c555f876d795c74ff"

  bottle do
    cellar :any
    revision 1
    sha256 "959e6543c21356acaf134f8a74e0004fcb8baa9b005bd372f82039d5f53be01e" => :el_capitan
    sha256 "90931e766efe645fce196f86061d0a673062af7a149b5cd8d05a735fc05d6421" => :yosemite
    sha256 "5ac845bf8d152a062059be1cb2c2db01d15c747a66d3cb5641abf3b8322376e5" => :mavericks
  end

  option :cxx11

  deprecated_option "imaging" => "with-imaging"

  option "with-imaging", "Build ImageIO and QT compoments of CGAL"
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

  depends_on "qt" if build.with? "imaging"
  depends_on "eigen" if build.with? "eigen3"

  # Allows to compile with clang 425: http://goo.gl/y9Dg2y
  patch :DATA

  def install
    ENV.cxx11 if build.cxx11?
    args = ["-DCMAKE_INSTALL_PREFIX=#{prefix}",
            "-DCMAKE_BUILD_TYPE=Release",
            "-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON",
            "-DCMAKE_INSTALL_NAME_DIR=#{HOMEBREW_PREFIX}/lib",
           ]
    if build.without? "imaging"
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
