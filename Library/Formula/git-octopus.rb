class GitOctopus < Formula
  desc "Extends git-merge with branch naming patterns"
  homepage "https://github.com/lesfurets/git-octopus"
  url "https://github.com/lesfurets/git-octopus/archive/v1.2.tar.gz"
  sha256 "723b2b380f611f41b777cec3689afe441f52482a2fd7dcb73ae2555102bcd1cf"

  bottle do
    cellar :any_skip_relocation
    sha256 "49b09ecce43923827192367c44f07ecf7c5c395c3369e6adb80852ef6d15fc80" => :el_capitan
    sha256 "ef168793e40ba5728986c3360fcfe94a4380b397f512c8fc1a059e18a77e654e" => :yosemite
    sha256 "652cf404f04177114e05e9b7b8d36f2018beed92ba8877d598023e259604e4e9" => :mavericks
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
    system "git", "add", "."
    system "git", "commit", "--message", "brewing"

    assert_equal "", shell_output("#{bin}/git-octopus 2>&1", 0).strip
  end
end
