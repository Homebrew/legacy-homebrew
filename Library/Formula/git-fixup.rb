class GitFixup < Formula
  desc "Alias for git commit --fixup <ref>"
  homepage "https://github.com/keis/git-fixup"
  url "https://github.com/keis/git-fixup/archive/v1.0.2.tar.gz"
  sha256 "e43bef5697927c8efa5f2b562ff8057bb30be828ec7327acba8d593f332eb4f8"

  head "https://github.com/keis/git-fixup.git", :branch => "master"

  bottle do
    cellar :any
    sha1 "51111ec8f5f517ea73a5c465dd5ce1b066bbc1f0" => :yosemite
    sha1 "3d018cad30af595c34cb2a9eaa5457d6665abf09" => :mavericks
    sha1 "324a7f422f26e2a84cb587b2005a0da36c3d08f7" => :mountain_lion
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
