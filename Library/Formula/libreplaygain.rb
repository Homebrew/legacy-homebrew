require 'formula'

class Libreplaygain < Formula
  homepage 'http://www.musepack.net/'
  url 'http://files.musepack.net/source/libreplaygain_r475.tar.gz'
  version 'r475'
  sha1 '7739b4b9cf46e0846663f707a9498a4db0345eaf'

  depends_on 'cmake' => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
    include.install 'include/replaygain/'
  end
end
