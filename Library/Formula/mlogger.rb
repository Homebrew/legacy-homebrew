require 'formula'

class Mlogger < Formula
  homepage 'https://github.com/nbrownus/mlogger'
  url 'https://github.com/nbrownus/mlogger/archive/v1.1.2.tar.gz'
  sha1 '504a8f69c1b2a91dd787b1862e197e08c81b71ee'

  def install
    system 'make'
    bin.install 'mlogger'
  end
end
