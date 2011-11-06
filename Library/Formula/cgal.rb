require 'formula'

class Cgal < Formula
  url 'https://gforge.inria.fr/frs/download.php/29125/CGAL-3.9.tar.gz'
  sha1 'cc99fad7116f221b6301326834f71ff65cebf2eb'
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
    args << '.'
    system "cmake", *args
    system "make install"
  end
end
