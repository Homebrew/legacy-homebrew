require 'formula'

class Alac < Formula
  homepage 'http://craz.net/programs/itunes/alac.html'
  url 'http://craz.net/programs/itunes/files/alac_decoder-0.2.0.tgz'
  sha1 'a620f6293ef2d9490927d21ec341bbeff13eabe8'

  def install
    system "make", "CFLAGS=#{ENV.cflags}", "CC=#{ENV.cc}"
    bin.install('alac')
  end
end
