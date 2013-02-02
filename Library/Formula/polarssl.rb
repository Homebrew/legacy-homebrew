require 'formula'

class Polarssl < Formula
  homepage 'http://polarssl.org/'
  url 'http://polarssl.org/code/releases/polarssl-1.2.4-gpl.tgz'
  sha1 '75690f234392e2d663abd66750a9e87ee627e3e8'

  depends_on 'cmake' => :build

  def install
    system "cmake", ".",  *std_cmake_args
    system "make"
    system "make install"
  end
end
