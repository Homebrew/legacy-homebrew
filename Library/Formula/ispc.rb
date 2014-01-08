require 'formula'

class Ispc < Formula
  homepage 'http://ispc.github.com'
  url 'http://downloads.sourceforge.net/project/ispcmirror/v1.5.0/ispc-v1.5.0-osx.tar.gz'
  sha1 'dc03fcc523ccab31a16ad4db1d9f8c755b4fcd38'

  def install
    bin.install 'ispc'
  end

  def test
    system "#{bin}/ispc", "-v"
  end
end
