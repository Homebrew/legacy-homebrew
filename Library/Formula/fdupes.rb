require 'formula'

class Fdupes < Formula
  url 'http://fdupes.googlecode.com/files/fdupes-1.40.tar.gz'
  homepage 'http://code.google.com/p/fdupes/'
  md5 '11de9ab4466089b6acbb62816b30b189'

  def install
    inreplace "Makefile", "gcc", "#{ENV.cc} #{ENV.cflags}"
    system "make fdupes"
    bin.install "fdupes"
    man1.install "fdupes.1"
  end
end
