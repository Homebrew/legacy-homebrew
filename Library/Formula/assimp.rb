require 'formula'

class Assimp < Formula
  homepage 'http://assimp.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/assimp/assimp-2.0/assimp--2.0.863-sdk.zip'
  sha1 'eb6938c134e7110a96243570e52a8b860d15d915'

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
