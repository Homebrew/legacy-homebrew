require 'formula'

class Webkit2png < Formula
  homepage 'http://www.paulhammond.org/webkit2png/'
  url 'https://github.com/paulhammond/webkit2png/archive/v0.6.tar.gz'
  sha1 '647bbdee40358e98c40542cd441cc0b84af75e36'

  def install
    bin.install 'webkit2png'
  end
end
