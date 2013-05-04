require 'formula'

class Chipmunk < Formula
  homepage 'http://chipmunk-physics.net/'
  url 'https://github.com/slembcke/Chipmunk-Physics/archive/Chipmunk-6.1.2.tar.gz'
  sha1 'a432411e3d464a2a260a4eb8cd28313c66f7505c'

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
