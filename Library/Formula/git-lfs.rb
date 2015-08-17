class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/github/git-lfs"
  url "https://github.com/github/git-lfs/archive/v0.5.4-homebrew.tar.gz"
  version "0.5.4"
  sha256 "cf860d56d86cda40a5b883b81f4d991617788c13d5e09be6b35c8bb9ac878ad7"

  bottle do
    cellar :any
    sha256 "e866568127b874c7829f43971a616b97ac4047a177f9128bdeddcfd3a5120841" => :yosemite
    sha256 "a043735ec2976520653261d4615897b9e2199e17bf811cd270a00959ee0e0660" => :mavericks
    sha256 "a467ea335510e5ac387cdf3f3c5896f8b65557bd1fbd30f780788b4d4352c650" => :mountain_lion
  end

  depends_on "go" => :build

  def install
    system "./script/bootstrap"
    bin.install "bin/git-lfs"
  end

  test do
    system "git", "init"
    system "git", "lfs", "track", "test"
    assert_match(/^test filter=lfs/, File.read(".gitattributes"))
  end
end
