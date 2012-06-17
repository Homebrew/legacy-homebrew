require 'formula'

class Cgal < Formula
  homepage 'http://www.cgal.org/'
  url 'https://gforge.inria.fr/frs/download.php/30387/CGAL-4.0.tar.gz'
  sha1 '3cbc6431918fe56146cd70713d6cfa6c37c0ad0c'

  depends_on 'cmake' => :build
  depends_on 'boost'
  depends_on 'gmp'
  depends_on 'mpfr'

  depends_on 'qt' if ARGV.include? '--imaging'

  def options
    [['--imaging', "Build ImageIO and QT compoments of CGAL"]]
  end

  def install
    args = ["-DCMAKE_INSTALL_PREFIX=#{prefix}",
            "-DCMAKE_BUILD_TYPE=Release",
            "-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON",
            "-DCMAKE_INSTALL_NAME_DIR=#{HOMEBREW_PREFIX}/lib"]
    unless ARGV.include? '--imaging'
      args << "-DWITH_CGAL_Qt3=OFF" << "-DWITH_CGAL_Qt4=OFF" << "-DWITH_CGAL_ImageIO=OFF"
    end
    args << '.'
    system "cmake", *args
    system "make install"
  end
end
