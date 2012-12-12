require 'formula'

class Cpmtools < Formula
  url 'http://www.moria.de/~michael/cpmtools/cpmtools-2.13.tar.gz'
  homepage 'http://www.moria.de/~michael/cpmtools/'
  sha1 'c7efb662a467b0341dc516dee1c36cd284740f8a'

  def install
    system "./configure", "--prefix=#{prefix}"

    bin.mkpath
    man1.mkpath
    man5.mkpath

    system "make install"
  end
end
