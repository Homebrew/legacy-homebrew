require 'formula'

class Keychain <Formula
  url 'http://www.funtoo.org/archive/keychain/keychain-2.7.0.tar.bz2'
  homepage 'http://www.funtoo.org/en/security/keychain/intro/'
  md5 'c5eecd36130d9e8617a77f96b746982d'

  def install
    system "make"
    bin.install "keychain"
    man1.install "keychain.1.gz"
    doc.install "ChangeLog"
    doc.install "README.rst"
  end
end
