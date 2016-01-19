class Idnits < Formula
  desc "Looks for problems in internet draft formatting"
  homepage "https://tools.ietf.org/tools/idnits/"
  url "https://tools.ietf.org/tools/idnits/idnits-2.13.02.tgz"
  sha256 "6e42b044c79dc4e616d10ee9e283c20acc741601811a6acfc0c0d310afdf0823"

  bottle :unneeded

  depends_on "aspell"

  def install
    bin.install "idnits"
  end
end
