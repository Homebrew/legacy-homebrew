require 'formula'

class Openmeeg < Formula
  homepage 'http://www-sop.inria.fr/athena/software/OpenMEEG/'
  url 'https://github.com/openmeeg/openmeeg/tarball/release-2.1'
  sha1 'b779f95db3687e5e338f889d9510b5777fdbdb79'

  head 'https://github.com/openmeeg/openmeeg.git'

  depends_on 'cmake' => :build
  depends_on 'hdf5'

  def install
    system "cmake", ".", "-DUSE_PROGRESSBAR=ON", *std_cmake_args
    system "make install"
  end
end
