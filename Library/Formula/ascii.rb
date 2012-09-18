require 'formula'

class Ascii < Formula
  homepage 'http://www.catb.org/~esr/ascii/'
  url 'http://www.catb.org/~esr/ascii/ascii-3.11.tar.gz'
  sha1 '8d033809d14fec814fc9a5818420718043a49e7b'

  def install
    system "make"
    bin.install "ascii"
    man1.install 'ascii.1'
  end
end
