require 'formula'

class Nrg2iso < Formula
  homepage 'http://gregory.kokanosky.free.fr/v4/linux/nrg2iso.en.html'
  url 'http://gregory.kokanosky.free.fr/v4/linux/nrg2iso-0.4.tar.gz'
  sha1 '26dfa9b489c9165dbc578ef3fddf6e491349df12'

  def install
    system "make"
    bin.install "nrg2iso"
  end
end
