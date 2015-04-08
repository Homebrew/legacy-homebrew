class GitLfs < Formula
  homepage "https://github.com/github/git-lfs"
  url "https://github.com/github/git-lfs/archive/v0.5.0.tar.gz"
  sha256 "70f17a594d51d1b92d2354a729f00546e9c1b2c93ff3b752e185c650c5442d06"

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
