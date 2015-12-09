class GitFresh < Formula
  desc "Utility to keep git repos fresh"
  homepage "https://github.com/imsky/git-fresh"
  url "https://github.com/imsky/git-fresh/archive/v1.2.3.tar.gz"
  sha256 "19f41d6c6f82b57fe02e6024f5ec46e72315e17fe01f0ddb29756bfd723c6a90"

  bottle :unneeded

  def install
    system "./install", bin
  end

  test do
    system "git", "init"
    system "git", "fresh"
  end
end
