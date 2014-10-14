require 'formula'

class Webkit2png < Formula
  homepage 'http://www.paulhammond.org/webkit2png/'
  url 'https://github.com/paulhammond/webkit2png/archive/v0.7.tar.gz'
  sha1 '41fe7dfb13125d6489245ad186a8e5a409c5d0a9'

  def install
    bin.install 'webkit2png'
  end
end
