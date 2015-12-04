class GitFixup < Formula
  desc "Alias for git commit --fixup <ref>"
  homepage "https://github.com/keis/git-fixup"
  url "https://github.com/keis/git-fixup/archive/v1.0.2.tar.gz"
  sha256 "e43bef5697927c8efa5f2b562ff8057bb30be828ec7327acba8d593f332eb4f8"

  head "https://github.com/keis/git-fixup.git", :branch => "master"

  bottle do
    cellar :any_skip_relocation
    sha256 "0a5e3f65dc07ee3aa2746068edf3cf6256acb0ef0bd44f37509ec35648a9d25c" => :el_capitan
    sha256 "77474bc651194209e99b061bf6b6753f36c8ce88b40870679023c0eedabf2c9e" => :yosemite
    sha256 "5e7a1711adbb5b2b46a426a50b103e8c145b34f5c585c75d0b728183fa8abe54" => :mavericks
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
    zsh_completion.install "completion.zsh" => "_git-fixup"
  end

  test do
    (testpath/".gitconfig").write <<-EOS.undent
      [user]
        name = Real Person
        email = notacat@hotmail.cat
      EOS
    system "git", "init"
    (testpath/"test").write "foo"
    system "git", "add", "test"
    system "git", "commit", "--message", "Initial commit"

    (testpath/"test").delete
    (testpath/"test").write "bar"
    system "git", "add", "test"
    system "git", "fixup"
  end
end
