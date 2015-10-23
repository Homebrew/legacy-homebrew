class Keychain < Formula
  desc "User-friendly front-end to ssh-agent(1)"
  homepage "http://www.funtoo.org/Keychain"
  url "http://build.funtoo.org/distfiles/keychain/keychain-2.8.1.tar.bz2"
  mirror "https://distfiles.macports.org/keychain/keychain-2.8.1.tar.bz2"
  sha256 "1568c0946db3638fe081d5a7ba3df022b533dbeb8aa67cd07dc8276e87598809"

  bottle :unneeded

  def install
    bin.install "keychain"
    man1.install "keychain.1"
  end
end
