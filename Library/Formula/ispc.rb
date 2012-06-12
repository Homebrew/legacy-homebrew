require 'formula'

class Ispc < Formula
  homepage 'http://ispc.github.com'
  url 'https://github.com/downloads/ispc/ispc/ispc-v1.2.2-osx.tar.gz'
  version '1.2.2'
  md5 '21f1fe1aabe47ae280e0dc92d50d564f'

  def install
    bin.install 'ispc'
  end

  def test
    system "#{bin}/ispc", "-v"
  end
end
