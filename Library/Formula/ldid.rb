require "formula"

class Ldid < Formula
  homepage "http://www.saurik.com/id/8"
  url "git://git.saurik.com/ldid.git"
  version "1.1.2"

  def install
    system "./make.sh"
    bin.install "ldid"
  end
end
