require 'formula'

class Darcs <Formula
  url 'http://darcs.net/releases/darcs-2.4.3.tar.gz'
  homepage 'http://darcs.net/'
  md5 '7263a8578f2a1f4e57ad90f3ad5bfe04'

  depends_on 'cabal'

  def install
    system "cabal", "update"
    system "cabal", "install", "--prefix", prefix
  end
end
