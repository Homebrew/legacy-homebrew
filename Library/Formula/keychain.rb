require 'formula'

class Keychain < Formula
  desc "User-friendly front-end to ssh-agent(1)"
  homepage 'http://www.funtoo.org/Keychain'
  url 'http://build.funtoo.org/distfiles/keychain/keychain-2.8.0.tar.bz2'
  mirror 'http://ftp.osuosl.org/pub/funtoo/distfiles/keychain/keychain-2.8.0.tar.bz2'
  sha256 '411bfe6a3ac9daca1c35f9a56828f03cc8474e8a668e122773397deb8f7a0799'

  bottle do
    cellar :any
    sha256 "adc5b68fb6f09789eb8680ddafff69cc1639de555162f122977e7d3fde2ed7d7" => :yosemite
    sha256 "fdca087e025f08bfc9241b0a83b079f0f3c6958fcde82adaba05a14a3f96ca4e" => :mavericks
    sha256 "dc9114d1a46f7a7e7826d2575abdaac0fcf88075e9fb0e2cf65e7076511512ef" => :mountain_lion
  end

  def install
    bin.install "keychain"
    man1.install "keychain.1"
  end
end
