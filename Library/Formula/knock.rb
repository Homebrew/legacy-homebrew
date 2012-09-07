require 'formula'

class Knock < Formula
  url 'http://www.zeroflux.org/proj/knock/files/knock-0.5.tar.gz'
  homepage 'http://www.zeroflux.org/projects/knock'
  sha1 '26f3b2f2d698bc6978390ef6e93c628361605059'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make knock man"
    bin.install "knock"
    man1.install Dir["doc/*.1"]
  end
end
