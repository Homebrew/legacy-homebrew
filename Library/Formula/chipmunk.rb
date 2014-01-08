require 'formula'

class Chipmunk < Formula
  homepage 'http://chipmunk-physics.net/'
  url 'https://github.com/slembcke/Chipmunk-Physics/archive/Chipmunk-6.1.5.tar.gz'
  sha1 'e15a919192fe95c5635f16fb8b11b1820dcf2c9a'

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
