require 'formula'

class Ascii < Formula
  homepage 'http://www.catb.org/~esr/ascii/'
  url 'http://www.catb.org/~esr/ascii/ascii-3.12.tar.gz'
  sha1 'aaeeb96a5a39d76a41bddc4504fdb97180beca9b'

  def install
    system "make"
    bin.install "ascii"
    man1.install 'ascii.1'
  end
end
