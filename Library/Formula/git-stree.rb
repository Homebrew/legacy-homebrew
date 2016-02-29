class GitStree < Formula
  desc "Git subtree helper command"
  homepage "https://github.com/tdd/git-stree"
  head "https://github.com/tdd/git-stree.git"
  url "https://github.com/tdd/git-stree/archive/0.4.5.tar.gz"
  sha256 "5504ac90871c73c92c21f5cd84b0bf956c521b237749e2b2dd699dbe0c096af8"

  bottle do
    cellar :any_skip_relocation
    sha256 "534f4d90c47779faa6df5d3bfa1f072596d0b3e7367bd3035d3782a6461e6b0c" => :el_capitan
    sha256 "dbd601412c4920f9a9767f38070df9cf184b0a08f4f1f1bc1e3bf3ec1fff6dd2" => :yosemite
    sha256 "d87889c5632ff79899110cbf182723da6ee5e9165f0ce88cacdbc7ac92476548" => :mavericks
    sha256 "7c4faa41a4c8b218ccb7ad0dd13e9312bead1f4ec518d3e9edf16e4897efb000" => :mountain_lion
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
