require 'formula'

class Assimp < Formula
  homepage 'http://assimp.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/assimp/assimp-2.0/assimp--2.0.863-sdk.zip'
  md5 '9f41662501bd9d9533c4cf03b7c25d5b'

  depends_on 'cmake' => :build
  depends_on 'boost'

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end

  def test
    system "#{bin}/assimp", "version"
  end
end
