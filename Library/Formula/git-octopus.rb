class GitOctopus < Formula
  desc "Extends git-merge with branch naming patterns"
  homepage "https://github.com/lesfurets/git-octopus"
  url "https://github.com/lesfurets/git-octopus/archive/v1.2.tar.gz"
  sha256 "723b2b380f611f41b777cec3689afe441f52482a2fd7dcb73ae2555102bcd1cf"

  bottle do
    cellar :any_skip_relocation
    sha256 "0d65c7084a3bcf37dbeaa8588c37d0ca46a8aa4c547b3227cb459c7e383d4ca7" => :el_capitan
    sha256 "84b80ab00ce8801ef6b222f073c849ebe52b7665f3241a9b791c15f6fe742880" => :yosemite
    sha256 "13b574740d23c12dbac5359bc7c28fc2aa736f1fa9d82d7b3f82c3d1bda457e6" => :mavericks
  end

  def install
    system "make", "build"
    bin.install "bin/git-octopus", "bin/git-conflict", "bin/git-apply-conflict-resolution"
    man1.install "doc/git-octopus.1", "doc/git-conflict.1"

    # Clearly need something here to point to git "doc/git-doc" instead of git-octopus "doc/git-doc"
    (share+"doc/git-doc").install "doc/git-octopus.html" "doc/git-octopus.html"
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
