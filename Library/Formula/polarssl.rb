require 'formula'

class Polarssl < Formula
  homepage 'http://polarssl.org/'
  url 'https://polarssl.org/code/releases/polarssl-1.2.7-gpl.tgz'
  sha256 'd64c2d1247f93cdeb884bd3706dfddffc636634bbf81d3772af750d5b5191328'

  depends_on 'cmake' => :build

  def install
    system "cmake", ".",  *std_cmake_args
    system "make"
    system "make install"
  end
end
