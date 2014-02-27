require 'formula'

class Ispc < Formula
  homepage 'http://ispc.github.io'
  url 'https://downloads.sourceforge.net/project/ispcmirror/v1.6.0/ispc-v1.6.0-osx.tar.gz'
  sha1 'cea50303a6bfcb213a485ada1337aa4b25807cb8'

  def install
    bin.install 'ispc'
  end

  test do
    system "#{bin}/ispc", "-v"
  end
end
