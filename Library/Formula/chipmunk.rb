require 'formula'

class Chipmunk < Formula
  homepage 'http://chipmunk-physics.net/'
  url 'https://github.com/slembcke/Chipmunk-Physics/tarball/Chipmunk-6.0.3'
  sha1 '28fdb3df0ca5347ad4f86321a8d8e330920c2e40'

  head 'https://github.com/slembcke/Chipmunk-Physics.git'

  depends_on 'cmake' => :build

  def install
    system "cmake", "-DCMAKE_INSTALL_PREFIX=#{prefix}",
                    "-DCMAKE_PREFIX_PATH=#{prefix}",
                    "-DPREFIX=#{prefix}",
                    "."
    system "make install"
  end
end
