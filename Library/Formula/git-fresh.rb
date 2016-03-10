class GitFresh < Formula
  desc "Utility to keep git repos fresh"
  homepage "https://github.com/imsky/git-fresh"
  url "https://github.com/imsky/git-fresh/archive/v1.5.0.tar.gz"
  sha256 "88196f1c28b938ba7da2504c4954244d18301649f33c1ec598e09f8e2a55055c"

  bottle :unneeded

  def install
    system "./install", bin
  end

  test do
    system "git", "init"
    system "git", "fresh"
  end
end
