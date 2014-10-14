require "formula"

class Daemonize < Formula
  homepage "http://software.clapper.org/daemonize/"
  url "https://github.com/bmc/daemonize/archive/release-1.7.5.tar.gz"
  sha1 "aa0edb1a71a898df0167c2bd426e76c187e19b49"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
