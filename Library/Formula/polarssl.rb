require 'formula'

class Polarssl < Formula
  homepage 'http://polarssl.org/'
  url 'http://polarssl.org/code/releases/polarssl-1.2.6-gpl.tgz'
  sha1 '063b953bb8bc65442c2c39551c5235e51c674055'

  depends_on 'cmake' => :build

  def install
    system "cmake", ".",  *std_cmake_args
    system "make"
    system "make install"
  end
end
