class Ievms < Formula
  desc "Automated installation of Microsoft IE AppCompat virtual machines"
  homepage "https://xdissent.github.io/ievms/"
  url "https://github.com/xdissent/ievms/archive/v0.2.1.tar.gz"
  sha256 "4c84c3f29eb93daa29f5c0a4159105b6bce9a8378971f42c6cbcfe5321f936ab"

  depends_on "unar"

  def install
    bin.install "ievms.sh" => "ievms"
  end
end
