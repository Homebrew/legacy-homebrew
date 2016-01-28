class Keychain < Formula
  desc "User-friendly front-end to ssh-agent(1)"
  homepage "http://www.funtoo.org/Keychain"
  url "http://build.funtoo.org/distfiles/keychain/keychain-2.8.2.tar.bz2"
  mirror "https://distfiles.macports.org/keychain/keychain-2.8.2.tar.bz2"
  sha256 "74895832297616a1a951e81a56603f2fc6e5449576411f8b122a5cc933ae3301"

  bottle :unneeded

  def install
    bin.install "keychain"
    man1.install "keychain.1"
  end
end
