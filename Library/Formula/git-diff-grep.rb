require 'formula'

class GitDiffGrep < Formula
  homepage 'https://github.com/oscardelben/git-diff-grep'
  head "https://github.com/oscardelben/git-diff-grep.git"

  def install
    bin.install "git-diff-grep" => "git-diff-grep"
  end

  def test
    system "brew test git-diff-grep"
  end
end
