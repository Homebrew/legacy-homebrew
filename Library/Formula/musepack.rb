require 'formula'

class Musepack < Formula
  homepage 'http://www.musepack.net/'
  url 'http://files.musepack.net/source/musepack_src_r475.tar.gz'
  version 'r475'
  sha1 'bdd4042773eb5c885df70d7a19914fa6e2306391'

  depends_on 'cmake' => :build
  depends_on 'libcuefile'
  depends_on 'libreplaygain'

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
    lib.install 'libmpcdec/libmpcdec.dylib'
  end
end
