require 'formula'

class Ispc < Formula
  homepage 'http://ispc.github.com'
  url 'http://downloads.sourceforge.net/project/ispcmirror/v1.4.4/ispc-v1.4.4-osx.tar.gz'
  sha1 '3db292eb38cb1651f1448cfa72541484f4be878a'

  def install
    bin.install 'ispc'
  end

  def test
    system "#{bin}/ispc", "-v"
  end
end
