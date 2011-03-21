require 'formula'

class Nrg2iso < Formula
  url 'http://gregory.kokanosky.free.fr/v4/linux/nrg2iso-0.4.tar.gz'
  homepage 'http://gregory.kokanosky.free.fr/v4/linux/nrg2iso.en.html'
  md5 '996c38c8f1465e9c51ccad4f31ec2eee'

  def install
    system "make"
    bin.install "nrg2iso"
  end
end
