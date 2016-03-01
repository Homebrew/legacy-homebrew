class GitVendor < Formula
  desc "command for managing git vendored dependencies"
  homepage "https://brettlangdon.github.io/git-vendor"
  url "https://github.com/brettlangdon/git-vendor/archive/v1.1.1.tar.gz"
  sha256 "e73a44e06e6576a0147958ef4aa37326dbb85e43981ee54a99a5475a16a3f687"
  head "https://github.com/brettlangdon/git-vendor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f0bb2c2364a14c8cc6a02f675433e0d030d049c2191a09de23ecf69904eb2d56" => :el_capitan
    sha256 "f7adc00d5b68e3590d7cc10152013d14c6b99d808214c74f42a05a1d3db5caee" => :yosemite
    sha256 "371068d0a8f6086099b25a3984b035324e6a6796013b64e7331ddcd5612e1999" => :mavericks
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
