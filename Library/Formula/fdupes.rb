require 'formula'

class Fdupes <Formula
  url 'http://netdial.caribe.net/~adrian2/programs/fdupes-1.40.tar.gz'
  homepage 'http://netdial.caribe.net/~adrian2/fdupes.html'
  md5 '11de9ab4466089b6acbb62816b30b189'

  def install
    inreplace "Makefile", "gcc", "#{ENV.cc} #{ENV.cflags}"
    system "make fdupes"
    bin.install "fdupes"
    man1.install "fdupes.1"
  end
end
