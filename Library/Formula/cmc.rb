require "formula"

class Cmc < Formula
  homepage "https://github.com/ClockworkNet/cmc"
  url "https://github.com/ClockworkNet/cmc/archive/1.0.0.tar.gz"
  sha1 "076fa44f1c26cb85ec1fb533c2768197106c2e2c"

  def install
    bin.install "cmc"
    prefix.install "LICENSE", "README.rst"
    doc.install Dir["docs/*"]
    doc.install_symlink prefix/"README.rst"
  end

end
