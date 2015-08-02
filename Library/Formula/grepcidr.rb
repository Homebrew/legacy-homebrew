require "formula"

class Grepcidr < Formula
  desc "Filter IP addresses matching IPv4 CIDR/network specification"
  homepage "http://www.pc-tools.net/unix/grepcidr/"
  url "http://www.pc-tools.net/files/unix/grepcidr-2.0.tar.gz"
  sha1 "5ec8cf18acbf92851b632d297b9fd6ee77c523ba"

  def install
    system "make"
    bin.install "grepcidr"
    man1.install "grepcidr.1"
  end
end
