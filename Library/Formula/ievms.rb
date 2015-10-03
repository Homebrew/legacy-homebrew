class Ievms < Formula
  desc "Automated installation of Microsoft IE AppCompat virtual machines"
  homepage "https://xdissent.github.io/ievms/"
  url "https://github.com/xdissent/ievms/archive/v0.3.1.tar.gz"
  sha256 "4db0b334fa9471f1116e56b472ffd24f92c4d8a2d6e016cd9d4060c6059664bb"

  depends_on "unar"

  def install
    bin.install "ievms.sh" => "ievms"
  end
end
