class Ipv6calc < Formula
  desc "Small utility for manipulating IPv6 addresses"
  homepage "http://www.deepspace6.net/projects/ipv6calc.html"
  url "ftp://ftp.deepspace6.net/pub/ds6/sources/ipv6calc/ipv6calc-0.94.1.tar.gz"
  sha256 "3bd73fd92c1d971fadea41b39830975b4a20bbcd26587dfb2835964b33de4040"

  def install
    # This needs --mandir, otherwise it tries to install to /share/man/man8.
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end
end
