require "formula"

class Ievms < Formula
  homepage "http://xdissent.github.io/ievms/"
  url "https://github.com/xdissent/ievms/archive/v0.2.1.tar.gz"
  sha1 "2379b323f3c5986a4a7a519ad2a158a0aa62a271"

  depends_on "unar"

  def install
    bin.install "ievms.sh" => "ievms"
  end
end
