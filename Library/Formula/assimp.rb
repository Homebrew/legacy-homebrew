require 'formula'

class Assimp < Formula
  url 'http://downloads.sourceforge.net/project/assimp/assimp-2.0/assimp--2.0.863-sdk.zip'
  homepage 'http://assimp.sourceforge.net/'
  md5 '9f41662501bd9d9533c4cf03b7c25d5b'
  version '2.0.863'

  depends_on 'cmake' => :build
  depends_on 'boost'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end

  def test
    system "assimp version"
  end
end
