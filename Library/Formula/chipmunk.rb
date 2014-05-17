require 'formula'

class Chipmunk < Formula
  homepage 'http://chipmunk-physics.net/'
  url 'https://chipmunk-physics.net/release/Chipmunk-6.x/Chipmunk-6.2.1.tgz'
  sha1 '593a15a9032586e56b16d22d84f4f04c1f11a44e'

  depends_on 'cmake' => :build

  def install
    system "cmake", "-DCMAKE_INSTALL_PREFIX=#{prefix}",
                    "-DCMAKE_BUILD_TYPE=Release",
                    "-DBUILD_DEMOS=OFF",
                    "."
    system "make install"
  end
end
