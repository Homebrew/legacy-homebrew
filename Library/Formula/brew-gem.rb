require 'formula'

class BrewGem < Formula
  homepage 'https://github.com/josh/brew-gem'
  url 'https://github.com/josh/brew-gem/tarball/v0.1.2'
  sha1 '03454394c9f6288c8aeee6e8523d3ef48d6f07c1'

  def install
    bin.install 'bin/brew-gem'
  end
end
