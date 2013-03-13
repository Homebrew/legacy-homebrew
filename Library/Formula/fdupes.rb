require 'formula'

class Fdupes < Formula
  homepage 'http://code.google.com/p/fdupes/'
  url 'http://fdupes.googlecode.com/files/fdupes-1.40.tar.gz'
  sha1 'e1bce9bdf50d7bf700dda3eb8a3d218b181b3931'

  def install
    inreplace "Makefile", "gcc", "#{ENV.cc} #{ENV.cflags}"
    system "make fdupes"
    bin.install "fdupes"
    man1.install "fdupes.1"
  end
end
