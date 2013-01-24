require 'formula'

class Polarssl < Formula
  homepage 'http://polarssl.org/'
  url 'http://polarssl.org/code/releases/polarssl-1.2.3-gpl.tgz'
  sha1 'b47b3db19c4487c5930eaec23dda0dbd24851146'

  depends_on 'cmake' => :build

  def install
    system "cmake", ".",  *std_cmake_args
    system "make"
    system "make install"
  end
end
