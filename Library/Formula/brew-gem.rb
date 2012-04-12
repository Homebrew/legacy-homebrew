require 'formula'

class BrewGem < Formula
  url 'https://github.com/josh/brew-gem/tarball/v0.1.2'
  homepage 'https://github.com/josh/brew-gem'
  md5 'c39f1c5db2e4d18349109aeed8136970'

  def install
    bin.install 'bin/brew-gem'
  end
end
