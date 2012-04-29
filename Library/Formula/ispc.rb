require 'formula'

class Ispc < Formula
  url 'https://github.com/downloads/ispc/ispc/ispc-v1.0.11-osx.tar.gz'
  homepage 'http://ispc.github.com'
  version '1.0.11'
  md5 '180324cac56b4a045120e2ad10de707d'

  def install
    bin.install 'ispc'
  end

  def test
    system "ispc -v"
  end
end
