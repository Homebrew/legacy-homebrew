require 'formula'

class Fasd < Formula
  homepage 'https://github.com/clvv/fasd'
  url 'https://github.com/clvv/fasd/tarball/0.7.0'
  sha1 'afc45b3c9dd29b20dbe80629d0774de4e5c1fc2b'

  def install
    bin.install 'fasd'
    man1.install 'fasd.1'
  end
end
