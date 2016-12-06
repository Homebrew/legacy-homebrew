require 'formula'

class Liblapack < Formula
  homepage 'http://www.netlib.org/lapack/'
  url 'http://www.netlib.org/lapack/lapack-3.4.2.tgz'
  sha1 '93a6e4e6639aaf00571d53a580ddc415416e868b'

  depends_on 'cmake' => :build

  def install
    ENV.fortran
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
