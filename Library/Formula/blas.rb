require 'formula'

class Blas <Formula
  url 'http://www.netlib.org/blas/blas.tgz'
  homepage 'http://www.netlib.org/blas/'
  version ''
  md5 ''

  # depends_on 'cmake'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
