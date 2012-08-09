require 'formula'

class Alac < Formula
  homepage 'http://craz.net/programs/itunes/alac.html'
  url 'http://craz.net/programs/itunes/files/alac_decoder-0.2.0.tgz'
  md5 'cec75c35f010d36e7bed91935b57f2d1'

  def install
    system "make", "CFLAGS=#{ENV.cflags}", "CC=#{ENV.cc}"
    bin.install('alac')
  end
end
