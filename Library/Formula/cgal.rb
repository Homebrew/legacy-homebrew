require 'formula'

class Cgal < Formula
  url 'https://gforge.inria.fr/frs/download.php/28500/CGAL-3.8.tar.gz'
  md5 'b8a79e62e4d8ba8b649d815aebbd1c0a'
  homepage 'http://www.cgal.org/'

  depends_on 'cmake' => :build
  depends_on 'boost'
  depends_on 'gmp'
  depends_on 'mpfr'

  depends_on 'qt' if ARGV.include? '--imaging'

  def options
    [['--imaging', "Build ImageIO and QT compoments of CGAL"]]
  end

  def install
    args = ["-DCMAKE_INSTALL_PREFIX=#{prefix}", "-DCMAKE_BUILD_TYPE=Release"]

    unless ARGV.include? '--imaging'
      args << "-DWITH_CGAL_Qt3=OFF" << "-DWITH_CGAL_Qt4=OFF" << "-DWITH_CGAL_ImageIO=OFF"
    end

    system "cmake", ".", *args
    system "make install"
  end
end
