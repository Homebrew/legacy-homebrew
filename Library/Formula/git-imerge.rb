require "formula"

class GitImerge < Formula
  homepage "https://github.com/mhagger/git-imerge"
  url "https://github.com/mhagger/git-imerge/archive/0.7.0.tar.gz"
  sha1 "b3bab94743a79426ea79c1b5e503020ef7fbf2ec"

  def install
    bin.install "git-imerge"
  end

  test do
    system "#{bin}/git-imerge", "-h"
  end
end
