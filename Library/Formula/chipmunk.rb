require 'formula'

class Chipmunk < Formula
  homepage 'http://chipmunk-physics.net/'
  url 'https://github.com/slembcke/Chipmunk-Physics/tarball/Chipmunk-6.0.3'
  md5 '50108c9bfa090b8a87e22043a4eb51be'

  head 'https://github.com/slembcke/Chipmunk-Physics.git'

  depends_on 'cmake' => :build

  def install
    system "cmake", "-DCMAKE_INSTALL_PREFIX=#{prefix}",
                    "-DCMAKE_PREFIX_PATH=#{prefix}",
                    "-DPREFIX=#{prefix}", "."
    system "make install"
  end
end
