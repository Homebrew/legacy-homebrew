require "formula"

class GitLatexdiff < Formula
  homepage "https://gitorious.org/git-latexdiff"
  url "git://gitorious.org/git-latexdiff/git-latexdiff.git", :tag => "v1.0.0"

  def install
    bin.install "git-latexdiff"
  end

  test do
    system "git", "latexdiff", "-h"
  end
end
