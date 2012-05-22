require 'formula'

class Musepack < Formula
  homepage 'http://www.musepack.net/'
  url 'http://files.musepack.net/source/musepack_src_r475.tar.gz'
  version 'r475'
  md5 '754d67be67f713e54baf70fcfdb2817e'

  depends_on 'cmake' => :build
  depends_on 'libcuefile'
  depends_on 'libreplaygain'

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
    lib.install 'libmpcdec/libmpcdec.dylib'
  end
end
