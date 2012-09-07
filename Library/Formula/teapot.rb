require 'formula'

class Teapot < Formula
  url 'http://www.syntax-k.de/projekte/teapot/teapot-1.09.tar.gz'
  homepage 'http://www.syntax-k.de/projekte/teapot/'
  sha1 '5618bcc3c2e10ed6af73a0f8ee29599c7fc5967d'

  def install
    system "make"
    bin.install 'teapot'
  end
end
