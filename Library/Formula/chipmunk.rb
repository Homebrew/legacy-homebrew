require 'formula'

class Chipmunk < Formula
  head 'http://chipmunk-physics.googlecode.com/svn/trunk'
  homepage 'http://code.google.com/p/chipmunk-physics/'

  depends_on 'cmake' => :build

  def install
    system "cmake", "-DCMAKE_INSTALL_PREFIX=#{prefix}",
                    "-DCMAKE_PREFIX_PATH=#{prefix}",
                    "-DPREFIX=#{prefix}", "."
    system "make install"
  end
end
