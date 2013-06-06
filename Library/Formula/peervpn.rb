require "formula"

class Peervpn < Formula
  homepage "http://www.peervpn.net"
  url "http://www.peervpn.net/files/peervpn-0-029.tar.gz"
  version "0.029"
  sha1 "ebe2214aa002de2a7c1c69f257f8113c2b6ac8a7"

  depends_on "tuntap"

  def patches
    "https://raw.github.com/gist/4170462/6460aa7cd015cc2a5f4128c5b1952b912073f5cd/freevpn0.029__platform__io.patch"
  end if MacOS.version == :snow_leopard

  def install
    system "make"
    bin.install "peervpn"
    etc.install "peervpn.conf" unless (etc/'peervpn.conf').exist?
  end

  def caveats; <<-EOS.undent
    To configure PeerVPN, edit:
      #{etc}/peervpn.conf
    EOS
  end

  def test
    system "#{bin}/peervpn"
  end
end
