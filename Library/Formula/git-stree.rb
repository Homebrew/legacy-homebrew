class GitStree < Formula
  homepage "https://github.com/tdd/git-stree"
  head "https://github.com/tdd/git-stree.git"
  url "https://github.com/tdd/git-stree/archive/0.4.5.tar.gz"
  sha256 "5504ac90871c73c92c21f5cd84b0bf956c521b237749e2b2dd699dbe0c096af8"

  bottle do
    cellar :any
    sha256 "268ae53b67f0f9063312492267a6eb54521f044127fdc69e148205aa43b8bd77" => :yosemite
    sha256 "d81c6f2a7631446fc1cd85b25bc72d3900661d8e9cc3c58bee553b240bc93223" => :mavericks
    sha256 "cfd20af0102baa792d35fded2bb5fd3a7ba505741d44bcd5c6b24d87be4d9925" => :mountain_lion
  end

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
