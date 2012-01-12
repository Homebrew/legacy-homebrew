require 'formula'

class Keychain < Formula
  url 'http://www.funtoo.org/archive/keychain/keychain-2.7.1.tar.bz2'
  homepage 'http://www.funtoo.org/en/security/keychain/intro/'
  md5 '07c622833192189f483cbaec287f9704'

  def install
    bin.install "keychain"
    man1.install "keychain.1"
    doc.install ["ChangeLog", "README.rst"]
  end
end
