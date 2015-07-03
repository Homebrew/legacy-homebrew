class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/github/git-lfs"
  url "https://github.com/github/git-lfs/archive/v0.5.2.tar.gz"
  sha256 "c7453d15fd817c50c5bff86e5bbd45781b3a7213cd70de9ff8f9240cf04fb626"

  bottle do
    cellar :any
    sha256 "796c25fb3b8efede11672dbf8dc87fb2c1ca7727dc96bb5e99e570eabe221ee5" => :yosemite
    sha256 "f8325f948d1cfd67db4ad64674919d08a0763bfabda9a2743f022ad7d14d69ea" => :mavericks
    sha256 "08d39395bc9107b37aeac9570f9bf225b624f19ad2b29bb416db44da06e7c975" => :mountain_lion
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/github"
    ln_s buildpath, buildpath/"src/github.com/github/git-lfs"
    system "./script/bootstrap"
    bin.install "bin/git-lfs"
  end

  test do
    system "git", "init"
    system "git", "lfs", "track", "test"
    assert_match(/^test filter=lfs/, File.read(".gitattributes"))
  end
end
