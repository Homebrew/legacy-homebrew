require 'formula'

class Gmsh < Formula
  homepage 'http://geuz.org/gmsh/#Download'
  url 'http://geuz.org/gmsh/src/gmsh-2.7.1-source.tgz'
  sha1 '891061eead68805dcb772acee217e1ea8f0775c5'

  depends_on 'cmake' => :build

  def install
    system "mkdir build && cd build"
    system "cmake .. -DCMAKE_INSTALL_PREFIX=#{prefix} -DDEFAULT=0"
    system "make"
    system "make install"
  end
end
