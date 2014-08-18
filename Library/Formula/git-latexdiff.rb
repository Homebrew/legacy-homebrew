require "formula"
class GitLatexdiff < Formula
  homepage "https://gitorious.org/git-latexdiff"
  url "git://gitorious.org/git-latexdiff/git-latexdiff.git"

  def install
    system "make", "install"
  end
end
