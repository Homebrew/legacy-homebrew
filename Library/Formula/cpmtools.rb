require 'formula'

class Cpmtools < Formula
  url 'http://www.moria.de/~michael/cpmtools/cpmtools-2.13.tar.gz'
  homepage 'http://www.moria.de/~michael/cpmtools/'
  md5 'd0622e33c80d2abb44cbe2e844285ce6'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    bin.mkdir
    share.mkdir
    man.mkdir
    man1.mkdir
    man5.mkdir
    system "make install"
  end
end
