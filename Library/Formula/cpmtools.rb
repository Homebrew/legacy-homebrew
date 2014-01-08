require 'formula'

class Cpmtools < Formula
  homepage 'http://www.moria.de/~michael/cpmtools/'
  url 'http://www.moria.de/~michael/cpmtools/cpmtools-2.16.tar.gz'
  sha1 'a63c381f868870f3a33ffacb552d5b4e8ede28eb'

  def install
    system "./configure", "--prefix=#{prefix}"

    bin.mkpath
    man1.mkpath
    man5.mkpath

    system "make install"
  end
end
