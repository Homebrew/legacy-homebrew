require 'formula'

class Spiped < Formula
  homepage 'http://www.tarsnap.com/spiped.html'
  url 'http://www.tarsnap.com/spiped/spiped-1.1.0.tgz'
  sha256 'b727b902310d217d56c07d503c4175c65387ff07c9cd50a24584903faf9f3dc3'

  depends_on :bsdmake

  def install
    system "bsdmake", "LDADD=-lcrypto", "BINDIR_DEFAULT=#{bin}", "install"
  end
end
