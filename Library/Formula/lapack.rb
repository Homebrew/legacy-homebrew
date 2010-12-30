require 'formula'

class Lapack <Formula
  url 'http://www.netlib.org/lapack/lapack.tgz'
  homepage 'http://www.netlib.org/lapack/'
  version '3.3.0'
  md5 '84213fca70936cc5f1b59a7b1bf71697'

  depends_on 'gfortran'

  def install
    #ENV["F99"] = "#{HOMEBREW_PREFIX}/bin/gfortran"
    #ENV["FFLAGS"] = ENV["CFLAGS"]
    #system "./configure", "--disable-debug", "--disable-dependency-tracking",
    #                      "--prefix=#{prefix}"
    # system "cmake . #{std_cmake_parameters}"
    system "cp INSTALL/make.inc.gfortran make.inc"
    system "make install"
  end
end
