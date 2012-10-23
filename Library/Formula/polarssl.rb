require 'formula'

class Polarssl < Formula
  homepage 'http://polarssl.org/'
  url 'http://polarssl.org/code/releases/polarssl-1.1.4-gpl.tgz'
  sha1 '3dd10bd1a8f7f58e0ef8c91cfa5ea7efd5d5f4bc'

  depends_on 'cmake' => :build

  def install
    system "cmake", ".",  *std_cmake_args
    system "make"
    system "make install"
  end
end
