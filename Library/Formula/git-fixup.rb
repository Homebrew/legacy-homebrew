class GitFixup < Formula
  homepage "https://github.com/keis/git-fixup"
  url "https://github.com/keis/git-fixup/archive/v1.0.0.tar.gz"
  sha1 "836613c7b9d1ccafaa5f5250b6ff2e125fabf974"

  head "https://github.com/keis/git-fixup.git", :branch => "master"

  def install
    system "make", "prefix=#{prefix}", "install"
    zsh_completion.install "completion.zsh" => "_git-fixup"
  end

  test do
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
