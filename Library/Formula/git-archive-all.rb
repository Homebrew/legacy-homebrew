class GitArchiveAll < Formula
  desc "Archive a project and its submodules"
  homepage "https://github.com/Kentzo/git-archive-all"
  url "https://github.com/Kentzo/git-archive-all/archive/1.13.tar.gz"
  sha256 "69bbe8039b71440b89ca7113b9c2178aa0602959f5f6c83b1cd52492384830eb"
  head "https://github.com/Kentzo/git-archive-all.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "89a57c45b31f6c308374a3b216898854f06e46406181bb67f810cbdfb2185f03" => :el_capitan
    sha256 "e86c067e55ab1b606e1b6e22cdbbd0a3558d3f017c5b0fce34a0008ab4b6b009" => :yosemite
    sha256 "f73f30739d852df99f7691d37c01174716b53868a1518f8116cfcff7aeb10ea6" => :mavericks
  end

  def install
    system "make", "prefix=#{prefix}", "install"
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

    assert_equal "#{testpath}/homebrew => archive/homebrew",
                 shell_output("#{bin}/git-archive-all --dry-run ./archive", 0).chomp
  end
end
