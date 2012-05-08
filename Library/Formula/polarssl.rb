require 'formula'

class Polarssl < Formula
  homepage 'http://polarssl.org/'
  url 'http://polarssl.org/code/releases/polarssl-1.1.3-gpl.tgz'
  md5 'fdd367e3b5ab43ed2af8ffbdfaf0fb81'

  depends_on 'cmake' => :build

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make"
    system "make install"
  end

end
