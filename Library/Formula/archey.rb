require 'formula'

class Archey < Formula
  homepage 'http://obihann.github.io/archey-osx/'
  url 'https://github.com/obihann/archey-osx/archive/1.3.tar.gz'
  sha1 '846d2cdc9922b5e8566ff00b71aa457dacf2f87e'

  def install
    bin.install 'bin/archey'
  end
end
