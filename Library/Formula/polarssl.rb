require 'formula'

class Polarssl < Formula
  homepage 'http://polarssl.org/'
  url 'https://polarssl.org/download/polarssl-1.3.1-gpl.tgz'
  sha1 'b33856a1b2f736b18a49a20d48986bce6b3133f5'

  depends_on 'cmake' => :build

  def install
    system "cmake", ".",  *std_cmake_args
    system "make"
    system "make install"
  end
end
