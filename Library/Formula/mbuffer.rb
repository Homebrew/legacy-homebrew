require "formula"

class Mbuffer < Formula
  homepage "http://www.maier-komor.de/mbuffer.html"
  url "http://lundman.net/ftp/osx.zfs/mbuffer-20130220-osx.tgz"
  sha1 "7b333f4706506576d43b9391e2af581473125416"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # test by sending mbuffer itself to devnull and hashing it
    system "#{bin}/mbuffer", "-i", "#{bin}/mbuffer", "-o", "/dev/null", "--md5"
  end
end
