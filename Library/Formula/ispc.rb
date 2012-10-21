require 'formula'

class Ispc < Formula
  homepage 'http://ispc.github.com'
  url 'https://github.com/downloads/ispc/ispc/ispc-v1.3.0-osx.tar.gz'
  version '1.3.0'
  sha1 'ec60f9e08405b6160b98aefd8cb4f9f7ee07c12e'

  def install
    bin.install 'ispc'
  end

  def test
    system "#{bin}/ispc", "-v"
  end
end
