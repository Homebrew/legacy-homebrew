class GitArchiveAll < Formula
  desc "Archive a project and its submodules"
  homepage "https://github.com/Kentzo/git-archive-all"
  url "https://github.com/Kentzo/git-archive-all/archive/1.13.tar.gz"
  sha256 "69bbe8039b71440b89ca7113b9c2178aa0602959f5f6c83b1cd52492384830eb"
  head "https://github.com/Kentzo/git-archive-all.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e94bb64970d3c206d6fdc7d7c7cbb5fb4668c8e6e405a8fbca51a995ab370f04" => :el_capitan
    sha256 "1f8d7abe64571e8275b03ae863b5510c2cf64bcb835f6f7f2a01ac359104fdde" => :yosemite
    sha256 "a87a857cb7880642838119bf6e1b45fa4ed37bae74ed99bd5270f857e7d04b00" => :mavericks
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
