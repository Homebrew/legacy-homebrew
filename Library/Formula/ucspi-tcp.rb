require 'formula'

class UcspiTcp < Formula
  homepage 'http://cr.yp.to/ucspi-tcp.html'
  url 'http://cr.yp.to/ucspi-tcp/ucspi-tcp-0.88.tar.gz'
  sha1 '793b4189795b563085602c030dd8aa0d206ddc0e'

  def patches
    "http://www.fefe.de/ucspi/ucspi-tcp-0.88-ipv6.diff19.bz2"
  end

  def install
    (buildpath/'conf-home').unlink
    (buildpath/'conf-home').write prefix

    system "make"
    system "make setup check"
    share.install prefix/'man'
  end

  def test
    system "tcpserver"
  end
end
