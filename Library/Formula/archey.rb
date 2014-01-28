require 'formula'

class Archey < Formula
  homepage 'http://obihann.github.io/archey-osx/'
  url 'https://github.com/obihann/archey-osx/archive/1.2.tar.gz'
  sha1 '4c93027246391be2abba7184e5170aeced09eeb9'

  def install
    bin.install 'bin/archey'
  end
end
