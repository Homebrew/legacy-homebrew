require 'formula'

class Cgal < Formula
  homepage 'http://www.cgal.org/'
  url 'https://gforge.inria.fr/frs/download.php/32359/CGAL-4.2.tar.gz'
  sha1 'df2a873f0a6dd9a7863f85c3de96a4be551f7ffd'

  option 'imaging', "Build ImageIO and QT compoments of CGAL"
  option 'with-eigen3', "Build with Eigen3 support"
  option 'with-lapack', "Build with LAPACK support"
  option 'with-c++11', 'Compile using Clang, std=c++11 and stdlib=libc++' if MacOS.version >= :lion

  depends_on 'cmake' => :build
  depends_on 'boost'
  depends_on 'gmp'
  depends_on 'mpfr'

  depends_on 'qt' if build.include? 'imaging'
  depends_on 'eigen' if build.include? 'with-eigen3'

  def patches
    { :p0 => DATA }
  end

  def install
    args = ["-DCMAKE_INSTALL_PREFIX=#{prefix}",
            "-DCMAKE_BUILD_TYPE=Release",
            "-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON",
            "-DCMAKE_INSTALL_NAME_DIR=#{HOMEBREW_PREFIX}/lib"]
    unless build.include? 'imaging'
      args << "-DWITH_CGAL_Qt3=OFF" << "-DWITH_CGAL_Qt4=OFF" << "-DWITH_CGAL_ImageIO=OFF"
    end
    if build.include? 'with-eigen3'
      args << "-DWITH_Eigen3=ON"
    end
    if build.include? 'with-lapack'
      args << "-DWITH_LAPACK=ON"
    end
    if build.include? 'with-c++11'
      args << "-DCGAL_CFG_NO_CPP0X_ARRAY=1"
      args << "-DCGAL_CFG_NO_TR1_ARRAY=1"
      args << "-DCGAL_CFG_NO_VARIADIC_TEMPLATES=1"
      args << "CXX=clang++ -std=c++11 -stdlib=libc++"
    end

    args << '.'
    system "cmake", *args
    system "make install"
  end
end

__END__
--- include/CGAL/Constrained_triangulation_2.h	2012-01-17 21:01:00.000000000 +0100
+++ include/CGAL/Constrained_triangulation_2.h	2012-04-16 11:35:58.859492000 +0200
@@ -541,7 +541,7 @@
 
   list_ab.push_back(Edge(lf, lf->index(current_face)));
   list_ba.push_front(Edge(rf, rf->index(current_face)));
-  intersected_faces.push_front(current_face);
+  intersected_faces.push_front(current_face.handle());
 
   // initcd
   previous_face=current_face; 
@@ -574,7 +574,7 @@
       }
       else {
 	lf= current_face->neighbor(i2);
-	intersected_faces.push_front(current_face);
+	intersected_faces.push_front(current_face.handle());
 	if (orient == LEFT_TURN) 
 	  list_ab.push_back(Edge(lf, lf->index(current_face)));
 	else // orient == RIGHT_TURN
@@ -590,7 +590,7 @@
     
   // last triangle 
   vi = current_vertex;
-  intersected_faces.push_front(current_face);
+  intersected_faces.push_front(current_face.handle());
   lf= current_face->neighbor(cw(ind));
   list_ab.push_back(Edge(lf, lf->index(current_face))); 
   rf= current_face->neighbor(ccw(ind));
