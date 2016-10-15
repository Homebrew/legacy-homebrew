require "formula"

class GitAll < Formula
  homepage "http://www.doublenot.co/git-all/"
  url "https://github.com/doublenot/git-all/archive/0.0.1.tar.gz"
  sha1 "b368e792923f5d0ce9fb90101c482a77ced8fe62"

  def install
    bin.install "git-all-clone"
    bin.install "git-all-config"
    bin.install "git-all-pull"
    bin.install "git-all-status"
  end

  def test
    which "git-all-clone"
  end
end
