require 'formula'

class Chipmunk < Formula
  homepage 'http://chipmunk-physics.net/'
  url 'https://github.com/slembcke/Chipmunk-Physics/tarball/Chipmunk-6.1.2'
  sha1 '8f4df376e6f45320c77e5ce9880c02ab7a284061'

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
