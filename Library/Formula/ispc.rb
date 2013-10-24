require 'formula'

class Ispc < Formula
  homepage 'http://ispc.github.com'
  url 'http://downloads.sourceforge.net/project/ispcmirror/v1.4.3/ispc-v1.4.3-osx.tar.gz'
  sha1 '7066f5447d704d0c97927f3e154646c88d7cda5d'

  def install
    bin.install 'ispc'
  end

  def test
    system "#{bin}/ispc", "-v"
  end
end
