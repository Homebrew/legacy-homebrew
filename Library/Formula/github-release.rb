class GithubRelease < Formula
  desc "Create and edit releases on Github (and upload artifacts)"
  homepage "https://github.com/aktau/github-release"
  url "https://github.com/aktau/github-release/archive/v0.6.2.tar.gz"
  sha256 "0f434345519664193d4ab270ea0150a31d604224e09b58dc948fa5930c5551ee"
  head "https://github.com/aktau/github-release.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "da81d46e83c078b2676a744f14a3e045264f92923e95160faf65f702de3bfd61" => :el_capitan
    sha256 "1ae83d9d5f18aeb437409199200b8bc95d7a8eaefd3d815457a7ec079ef1bdcd" => :yosemite
    sha256 "7023a11e0dbe16b7bbdafdc784a1ad28488251f1c17ecfb010542ce0c64a54e7" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "make"
    bin.install "github-release"
  end

  test do
    system "#{bin}/github-release", "info", "--user", "aktau",
                                            "--repo", "github-release",
                                            "--tag", "v#{version}"
  end
end
