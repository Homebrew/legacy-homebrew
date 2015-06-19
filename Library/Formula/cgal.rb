require 'formula'

class Cgal < Formula
  desc "CGAL: Computational Geometry Algorithm Library"
  homepage 'http://www.cgal.org/'
  url 'https://gforge.inria.fr/frs/download.php/file/34704/CGAL-4.6.tar.gz'
  sha1 'fed9a1d95bbf1620c9d7c7fbecd3c651702dd529'

  bottle do
    sha256 "27a0904eca24b6093b9612b5a12fb016f1e3a20b3739ec2db907abbca30ae9e4" => :yosemite
    sha256 "0491330f4e188301342a6591325c4b6239a49ab394e303781e7e591a77efd02d" => :mavericks
    sha256 "10d4636e402f13cbf5bd8777cb92cd63deb7464f49c0944b585cb44b3f8bc9ee" => :mountain_lion
  end

  option :cxx11

  option 'imaging', "Build ImageIO and QT compoments of CGAL"
  option 'with-eigen3', "Build with Eigen3 support"
  option 'with-lapack', "Build with LAPACK support"

  depends_on 'cmake' => :build
  if build.cxx11?
    depends_on 'boost' => 'c++11'
    depends_on 'gmp'   => 'c++11'
  else
    depends_on 'boost'
    depends_on 'gmp'
  end
  depends_on 'mpfr'

  depends_on 'qt' if build.include? 'imaging'
  depends_on 'eigen' if build.with? "eigen3"

  # Allows to compile with clang 425: http://goo.gl/y9Dg2y
  patch :DATA

  def install
    ENV.cxx11 if build.cxx11?
    args = ["-DCMAKE_INSTALL_PREFIX=#{prefix}",
            "-DCMAKE_BUILD_TYPE=Release",
            "-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON",
            "-DCMAKE_INSTALL_NAME_DIR=#{HOMEBREW_PREFIX}/lib"]
    unless build.include? 'imaging'
      args << "-DWITH_CGAL_Qt3=OFF" << "-DWITH_CGAL_Qt4=OFF" << "-DWITH_CGAL_ImageIO=OFF"
    end
    if build.with? "eigen3"
      args << "-DWITH_Eigen3=ON"
    end
    if build.with? "lapack"
      args << "-DWITH_LAPACK=ON"
    end
    args << '.'
    system "cmake", *args
    system "make install"
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
