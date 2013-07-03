require 'formula'

class Cgal < Formula
  homepage 'http://www.cgal.org/'
  url 'https://gforge.inria.fr/frs/download.php/32359/CGAL-4.2.tar.gz'
  sha1 'df2a873f0a6dd9a7863f85c3de96a4be551f7ffd'

  option 'imaging', "Build ImageIO and QT compoments of CGAL"
  option 'with-eigen3', "Build with Eigen3 support"
  option 'with-lapack', "Build with LAPACK support"

  depends_on 'cmake' => :build
  depends_on 'boost'
  depends_on 'gmp'
  depends_on 'mpfr'

  depends_on 'qt' if build.include? 'imaging'
  depends_on 'eigen' if build.include? 'with-eigen3'

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
    args << '.'
    system "cmake", *args
    system "make install"
  end
end
