require 'formula'

class Keychain < Formula
  homepage 'http://www.funtoo.org/wiki/Keychain'
  url 'https://github.com/funtoo/keychain.git',
    :revision => '7bca870a1f920820adf0e4fa319b30b7e4985ed3'
  version '2.7.1'
  head 'https://github.com/funtoo/keychain.git'

  def install
    system 'make'
    bin.install 'keychain'
    man1.install 'keychain.1'
  end
end
