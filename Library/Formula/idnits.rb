class Idnits < Formula
  homepage "https://tools.ietf.org/tools/idnits/"
  url "https://tools.ietf.org/tools/idnits/idnits-2.13.00.tgz"
  sha1 "25a390110679257706b2498f6519963b4f75d867"

  depends_on "aspell"

  def install
    bin.install "idnits"
  end
end
