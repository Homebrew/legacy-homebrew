require 'formula'

class Ttf2eot < Formula
  homepage 'http://code.google.com/p/ttf2eot/'
  url 'http://ttf2eot.googlecode.com/files/ttf2eot-0.0.2-2.tar.gz'
  sha1 'c9a64216e7a090cb50f7a5074865218623dea75d'

  def install
    system "make"
    bin.install 'ttf2eot'
  end
end
