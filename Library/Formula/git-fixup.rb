class GitFixup < Formula
  homepage "https://github.com/keis/git-fixup"
  url "https://github.com/keis/git-fixup/archive/v1.0.1.tar.gz"
  sha1 "0c2f2dd1f6543e537291c0f9e0e06905725b0ccc"

  head "https://github.com/keis/git-fixup.git", :branch => "master"

  bottle do
    cellar :any
    sha1 "8785269ef827076ed2dd7bf510b759294774a995" => :yosemite
    sha1 "22c609efffe6737c1cbb2b3abe7b152a07b4f6af" => :mavericks
    sha1 "8c47db51e200c21cb69c7c64ace23412c6ee93b2" => :mountain_lion
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
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
