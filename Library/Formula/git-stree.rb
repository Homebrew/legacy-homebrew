class GitStree < Formula
  homepage "https://github.com/tdd/git-stree"
  head "https://github.com/tdd/git-stree.git"
  url "https://github.com/tdd/git-stree/archive/v0.4.0.tar.gz"
  sha256 "c04d19c8eb1a566a8e7f373d447ab7e3480ee95f94802fa957afeb22c4bed0ef"

  def install
    bin.install "git-stree"
    bash_completion.install "git-stree-completion.bash" => "git-stree"
  end

  test do
    mkdir "mod" do
      system "git", "init"
      touch "HELLO"
      system "git", "add", "HELLO"
      system "git", "commit", "-m", "testing"
    end

    mkdir "container" do
      system "git", "init"
      touch ".gitignore"
      system "git", "add", ".gitignore"
      system "git", "commit", "-m", "testing"

      system "git", "stree", "add", "mod", "-P", "mod", "../mod"
    end
  end
end
