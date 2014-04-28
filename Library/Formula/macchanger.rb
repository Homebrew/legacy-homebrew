require "formula"

class Macchanger < Formula
  homepage "https://github.com/acrogenesis/macchanger"
  url "https://github.com/acrogenesis/macchanger/archive/v0.1.tar.gz"
  sha1 "b91155024d387683530e98e19c0c1b3d9703b101"

  def install
    bin.install "bin/macchanger"
  end

end
