require 'formula'

class Keychain < Formula
  homepage 'http://www.funtoo.org/wiki/Keychain'
  url 'http://www.funtoo.org/archive/keychain/keychain-2.7.1.tar.bz2'
  sha1 'e7ad7da374ba81e57792bb2695eb6c352f769de7'

  def install
    bin.install "keychain"
    man1.install "keychain.1"
  end
end
