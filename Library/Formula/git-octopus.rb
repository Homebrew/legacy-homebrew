class GitOctopus < Formula
  desc "Extends git-merge with branch naming patterns"
  homepage "https://github.com/lesfurets/git-octopus"
  url "https://github.com/lesfurets/git-octopus/archive/v1.1.1.tar.gz"
  sha256 "ff701edeeff139fc3086b3c05ead1efabac909453dbc9673508a3869c52dfb97"

  bottle do
    cellar :any
    sha256 "4979b6cf8a420382ea66d5afa883bdb28f76405c70f56f89a063123d9c6cafdf" => :yosemite
    sha256 "8112153bc59267178cfc95fc1b30adbea362c3cd62bd39947de6b41aedcf0a1d" => :mavericks
    sha256 "08dd8fe44df56b08d525310db0142bb77494ae614ab85ed08ee5fbf263a393d5" => :mountain_lion
  end

  def install
    system "make", "build"
    bin.install "bin/git-octopus", "bin/git-conflict", "bin/git-apply-conflict-resolution"
    man1.install "doc/git-octopus.1", "doc/git-conflict.1"
  end

  test do
    (testpath/".gitconfig").write <<-EOS.undent
      [user]
        name = Real Person
        email = notacat@hotmail.cat
      EOS
    system "git", "init"
    touch "homebrew"
    system "git", "add", "homebrew"
    system "git", "commit", "--message", "brewing"

    assert_equal "", shell_output("#{bin}/git-octopus 2>&1", 0).strip
  end
end
