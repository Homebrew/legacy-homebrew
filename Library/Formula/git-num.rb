class GitNum < Formula
  desc "Quickly (un)stage files in Git using numbers"
  homepage "https://github.com/schreifels/git-num"
  url "https://github.com/schreifels/git-num/archive/v1.0.0.tar.gz"
  version "1.0.0"
  sha256 "7d3e4e04b35fc604a709b12172ce72fc5edef695687755c78d3b4b221aca7a5a"

  def install
    bin.install "git-num"
  end

end
