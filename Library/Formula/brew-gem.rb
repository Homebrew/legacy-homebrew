require 'formula'

class BrewGem < Formula
  homepage 'https://github.com/josh/brew-gem'
  url 'https://github.com/josh/brew-gem/archive/v0.1.2.tar.gz'
  sha1 'fccccc5e7f00cbd69ff66c3f9a0e365bfb39641e'

  def install
    bin.install 'bin/brew-gem'
  end
end
