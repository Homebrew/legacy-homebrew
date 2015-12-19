class Cgal < Formula
  desc "CGAL: Computational Geometry Algorithm Library"
  homepage "http://www.cgal.org/"
  url "https://github.com/CGAL/cgal/releases/download/releases%2FCGAL-4.7/CGAL-4.7.tar.gz"
  sha256 "1be058fe9fc4d8331b48daf8beb114a049fd4970220d8a570ff709b7789dacae"

  bottle do
    cellar :any
    sha256 "10d807979225870180b7a77a54923e451dce8bd0b0fc5bacdd1a3c074769045d" => :el_capitan
    sha256 "c23e7870b3b9d8f152f2a2cf39df0a399b3fd419e2bd0c246768722dcfc31ad5" => :yosemite
    sha256 "ba56ab4ee49f038a1cadf7dd8e3c03b0ecd1cd1a531d608ae360adfb03d0410a" => :mavericks
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
