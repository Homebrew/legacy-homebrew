require 'formula'

class Keychain < Formula
  homepage 'http://www.funtoo.org/Keychain'
  url 'http://build.funtoo.org/distfiles/keychain/keychain-2.8.0.tar.bz2'
  mirror 'http://ftp.osuosl.org/pub/funtoo/distfiles/keychain/keychain-2.8.0.tar.bz2'
  sha256 '411bfe6a3ac9daca1c35f9a56828f03cc8474e8a668e122773397deb8f7a0799'

  def install
    bin.install "keychain"
    man1.install "keychain.1"
  end
end
