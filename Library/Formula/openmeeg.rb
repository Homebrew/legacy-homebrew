require 'formula'

class Openmeeg < Formula
  homepage 'http://www-sop.inria.fr/athena/software/OpenMEEG/'
  url 'https://github.com/openmeeg/openmeeg/archive/release-2.1.tar.gz'
  sha1 'c19896bde64e751142c74d15bf99defec518a054'

  head 'https://github.com/openmeeg/openmeeg.git'

  depends_on 'cmake' => :build
  depends_on 'hdf5'

  def install
    system "cmake", ".", "-DUSE_PROGRESSBAR=ON", *std_cmake_args
    system "make install"
  end
end
