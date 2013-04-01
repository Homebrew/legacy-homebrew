require 'formula'

class BrewPip < Formula
  homepage 'https://github.com/josh/brew-pip'
  url 'https://github.com/josh/brew-pip/archive/v0.1.2.tar.gz'
  sha1 '49fbd82ceb601e98999cbd28c106a7c26ff16a2b'

  def install
    bin.install 'bin/brew-pip'
  end
end
