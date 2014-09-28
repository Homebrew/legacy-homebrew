require "formula"

class Rmate < Formula
  homepage "https://github.com/textmate/rmate"
  url "https://raw.github.com/textmate/rmate/v1.5.7/bin/rmate"
  version "1.5.7"
  sha1 "899e71af9b4e340acca6848cdaffe01a59bb62c0"

  def install
    bin.install "rmate"
  end
end
