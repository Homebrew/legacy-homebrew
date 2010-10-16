require 'formula'

class Cgal <Formula
  url 'https://gforge.inria.fr/frs/download.php/26688/CGAL-3.6.tar.gz'
  md5 '78dbaf85df0a53ca0e87308d9cbf671e'
  homepage 'http://www.cgal.org/'

  depends_on 'cmake' => :build
  depends_on 'boost'
  depends_on 'gmp'
  depends_on 'mpfr'
  depends_on 'qt' => :optional

  def install
    system "cmake", ".", "-DCMAKE_INSTALL_PREFIX=#{prefix}", "-DCMAKE_BUILD_TYPE=Release"
    system "make install"
  end
end
