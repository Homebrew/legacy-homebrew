require "formula"

class GithubRelease < Formula
  homepage "https://github.com/aktau/github-release"
  url "https://github.com/aktau/github-release/archive/v0.5.2.tar.gz"
  sha1 "684391c8bfbb80e43e9aa328b640aaca10345bd7"

  head "https://github.com/aktau/github-release.git"
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
