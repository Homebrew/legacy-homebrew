require 'formula'

class Knock < Formula
  homepage 'http://www.zeroflux.org/projects/knock'
  url 'http://www.zeroflux.org/proj/knock/files/knock-0.5.tar.gz'
  sha1 '26f3b2f2d698bc6978390ef6e93c628361605059'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make knock man"
    bin.install "knock"
    man1.install Dir["doc/*.1"]
  end
end
