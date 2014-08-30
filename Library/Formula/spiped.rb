require 'formula'

class Spiped < Formula
  homepage 'https://www.tarsnap.com/spiped.html'
  url 'https://www.tarsnap.com/spiped/spiped-1.3.1.tgz'
  sha256 '8a58a983be460b88ed5a105201a0f0afacb83382208761837a62871dcca42fee'

  depends_on :bsdmake
  depends_on 'openssl'

  def install
    man1.mkpath
    system "bsdmake", "BINDIR_DEFAULT=#{bin}", "MAN1DIR=#{man1}", "install"
    doc.install 'spiped/README' => 'README.spiped',
                'spipe/README' => 'README.spipe'
  end
end
