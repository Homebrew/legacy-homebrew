require 'formula'

class Archey < Formula
  homepage 'http://obihann.github.io/archey-osx/'
  url 'https://github.com/obihann/archey-osx/archive/1.2.tar.gz'
  sha1 '61fe422a37f07a1c24762244a355bf992452dae4'

  def install
    bin.install 'bin/archey'
  end
end
