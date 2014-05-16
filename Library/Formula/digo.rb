require 'formula'

class Digo < Formula
  homepage 'https://github.com/dynport/digo/'
  url      'https://github.com/dynport/digo/releases/download/v0.1.3/digo-v0.1.3.darwin.amd64.tar.gz'
  sha1     'def1cd5fefe4144fccd8d512a835e6a3e19d9e12'

  def install
    bin.install 'digo'
  end
end
