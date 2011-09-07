require 'formula'

class Ascii < Formula
  url 'http://www.catb.org/~esr/ascii/ascii-3.10.tar.gz'
  homepage 'http://www.catb.org/~esr/ascii/'
  md5 '9dcae3ab8b097efd16a24c5d20e0044e'

  def install
    system "make"
    bin.install "ascii"
  end
end
