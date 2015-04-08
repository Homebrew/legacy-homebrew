class GitLfs < Formula
  homepage "https://github.com/github/git-lfs"
  url "https://github.com/github/git-lfs/archive/v0.5.0.tar.gz"
  sha256 "70f17a594d51d1b92d2354a729f00546e9c1b2c93ff3b752e185c650c5442d06"

  bottle do
    cellar :any
    sha256 "9716f5404c9362d7c5e5e25a90b48d4cecfbcc264b48ce53f3b8a9a167d4b627" => :yosemite
    sha256 "f05531186f2c69589a521065599808eb30e39973d1ff776a19673c3dcd617e5d" => :mavericks
    sha256 "d5d08a58daad4267681a72fbbb11e61886cacd4a8c1c6889391eab6d5e23ced6" => :mountain_lion
  end

  depends_on "go" => :build

  def install
    system "./script/bootstrap"
    bin.install "bin/git-lfs"
  end

  test do
    system "git", "lfs", "track", "test"
    assert_match(/^test filter=lfs/, File.read(".gitattributes"))
  end
end
