class GitFresh < Formula
  desc "Utility to keep git repos fresh"
  homepage "https://github.com/imsky/git-fresh"
  url "https://github.com/imsky/git-fresh/archive/v1.6.1.tar.gz"
  sha256 "4820bf8883bdb5623130ebeba397426e3cc0d639ce0f95313ac28f6d33ec17a2"

  bottle :unneeded

  def install
    system "./install.sh", bin
  end

  test do
    system "git-fresh", "-T"
  end
end
