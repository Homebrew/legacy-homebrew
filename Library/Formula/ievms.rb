require "formula"

class Ievms < Formula
  homepage "http://xdissent.github.io/ievms/"
  url "https://github.com/xdissent/ievms/archive/v0.2.0.tar.gz"
  sha1 "5cf742663ccce06579968a17bb559606ff4479e2"

  depends_on "unar"

  def install
    bin.install "ievms.sh" => "ievms"
  end
end
