require 'formula'

class Lapack <Formula
  url 'http://www.netlib.org/lapack/lapack-3.3.0.tgz'
  homepage 'http://www.netlib.org/lapack/'
  md5 '84213fca70936cc5f1b59a7b1bf71697'

  depends_on 'cmake' => :build
  depends_on 'gfortran' => :build

  def install

	# Select the Fortran compiler to be used:
    ENV["FC"] = ENV["F77"] = "#{HOMEBREW_PREFIX}/bin/gfortran"

    # Set Fortran optimization flags:
    ENV["FFLAGS"] = ENV["FCFLAGS"] = ENV["CFLAGS"]
    system "cmake -DCMAKE_BUILD_TYPE='Release' . "
    system "make install"
  end
end
