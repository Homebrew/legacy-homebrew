require 'formula'

class Cvode <Formula
  url 'https://computation.llnl.gov/casc/sundials/download/code/cvode-2.6.0.tar.gz'
  homepage ''
  md5 'e0fc83affd72b942a7cea4f33cb602be'

# depends_on 'cmake'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
#   system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
