class GitVendor < Formula
  desc "command for managing git vendored dependencies"
  homepage "https://brettlangdon.github.io/git-vendor"
  url "https://github.com/brettlangdon/git-vendor/archive/v1.1.0.tar.gz"
  sha256 "1a4db75631af559152f19b41867c23c0fe6c4ff30117afa6ab2d02a5802b89e6"
  head "https://github.com/brettlangdon/git-vendor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1c62ec5598b0a429a2913ce154db1f84f893b99cbe52596a9261a1870ab6402c" => :el_capitan
    sha256 "c3e835f79e5adb83ac8e636942456572dbad94f9274ce59624809dbec6b407fd" => :yosemite
    sha256 "a755a70a1c0233f788c70af7cec544396b57b89b7a571100e0afdc3b8e6a1fec" => :mavericks
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "git", "init"
    system "git", "config", "user.email", "author@example.com"
    system "git", "config", "user.name", "Au Thor"
    system "git", "add", "."
    system "git", "commit", "-m", "Initial commit"
    system "git", "vendor", "add", "git-vendor", "https://github.com/brettlangdon/git-vendor", "v1.1.0"
    assert_match "git-vendor@v1.1.0", shell_output("git vendor list")
  end
end
