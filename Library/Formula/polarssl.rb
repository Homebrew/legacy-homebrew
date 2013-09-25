require 'formula'

class Polarssl < Formula
  homepage 'http://polarssl.org/'
  url 'https://polarssl.org/code/releases/polarssl-1.2.8-gpl.tgz'
  sha1 'a3e69d4e9302529c5006dcb7d8ecab9c99488036'

  depends_on 'cmake' => :build

  def install
    system "cmake", ".",  *std_cmake_args
    system "make"
    system "make install"
  end
end
