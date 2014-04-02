require "formula"

class GitMap < Formula
  homepage "https://github.com/clarkema/git-map"
  url "https://github.com/clarkema/git-map/archive/v0.0.3.tar.gz"
  sha1 "eea43a160d2cf68d30fc421da8b8ae96dccdd89e"

  def install
    system "pod2man ./bin/git-map > git-map.1"
    bin.install "bin/git-map"
    man1.install "git-map.1"
  end

  test do
    system "git-map"
  end
end
