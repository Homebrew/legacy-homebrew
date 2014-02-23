require 'formula'

class Dwatch < Formula
  homepage 'http://siag.nu/dwatch/'
  url 'http://siag.nu/pub/dwatch/dwatch-0.1.1.tar.gz'
  sha1 'd1588364fcbad85b7ba81fa027199e983de55435'

  def install
    # Makefile uses cp, not install
    bin.mkpath
    man1.mkpath

    system "make", "install",
                   "CC=#{ENV.cc}",
                   "PREFIX=#{prefix}",
                   "MANDIR=#{man}",
                   "ETCDIR=#{etc}"

    etc.install "dwatch.conf"
  end

  test do
    # '-h' is not actually an option, but it exits 0
    system "#{bin}/dwatch", "-h"
  end
end
