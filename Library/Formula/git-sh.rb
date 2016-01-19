class GitSh < Formula
  desc "Customized Bash environment for git work"
  homepage "https://github.com/rtomayko/git-sh"
  url "https://github.com/rtomayko/git-sh/archive/1.3.tar.gz"
  sha256 "461848dfa52ea6dd6cd0a374c52404b632204dc637cde17c0532529107d52358"

  head "https://github.com/rtomayko/git-sh.git"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/git-sh", "-c", "ls"
  end
end
