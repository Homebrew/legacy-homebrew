require "formula"

class Peervpn < Formula
  homepage "http://www.peervpn.net"
  url "http://www.peervpn.net/files/peervpn-0-029.tar.gz"
  sha1 "ebe2214aa002de2a7c1c69f257f8113c2b6ac8a7"
  version "0.029"

  depends_on "tuntap"

  def install
    system "make"
    bin.install "peervpn"
    etc.install "peervpn.conf"
  end

  def patches
    if MacOS.version == :snow_leopard;
        ["https://raw.github.com/gist/4170462/6460aa7cd015cc2a5f4128c5b1952b912073f5cd/freevpn0.029__platform__io.patch"]
    end
  end

  def caveats
    message = "Don't forget to edit: " + etc + "/peervpn.conf to configure PeerVPN!"
  end

  def test
    system "peervpn"
  end
end
