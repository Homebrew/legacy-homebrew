require "formula"

class GithubRelease < Formula
  homepage "https://github.com/aktau/github-release"
  url "https://github.com/aktau/github-release/archive/v0.5.2.tar.gz"
  sha1 "684391c8bfbb80e43e9aa328b640aaca10345bd7"

  head "https://github.com/aktau/github-release.git"

  bottle do
    sha1 "c06950368dc90e472c0d6ec991ad639882240d25" => :mavericks
    sha1 "2a32068dfebc31be1a4610f778f300acb10e619c" => :mountain_lion
    sha1 "e6568e7a6ab65e13d54f7cfe2109ec621953f707" => :lion
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "make"
    bin.install "github-release"
  end

  test do
    system "#{bin}/github-release", "info", "--user", "aktau", "--repo", "github-release", "--tag", "v#{version}"
  end
end
