require 'formula'

class Cpmtools < Formula
  url 'http://www.moria.de/~michael/cpmtools/cpmtools-2.13.tar.gz'
  homepage 'http://www.moria.de/~michael/cpmtools/'
  md5 'd0622e33c80d2abb44cbe2e844285ce6'

  def install
    system "./configure", "--prefix=#{prefix}"

    bin.mkpath
    man1.mkpath
    man5.mkpath

    system "make install"
  end
end
