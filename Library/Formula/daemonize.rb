require "formula"

class Daemonize < Formula
  homepage "http://software.clapper.org/daemonize/"
  url "https://github.com/bmc/daemonize/archive/release-1.7.6.tar.gz"
  sha1 "5fec633880ef0a81fe0ca9d9eaeeeefd969f5dbd"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
