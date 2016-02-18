require "language/go"

class Glide < Formula
  desc "Simplified Go project management, dependency management, and vendoring"
  homepage "https://github.com/Masterminds/glide"
  url "https://github.com/Masterminds/glide/archive/0.9.0.tar.gz"
  sha256 "cad71acb42ff1415eea30c0c6a875665e5fc7efb2ed222b3a66286521b1c5b05"
  head "https://github.com/Masterminds/glide.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "775bef47edb206a2f466dee107d1165b0ae7cef7ffd376330d8e136dcdd2d8df" => :el_capitan
    sha256 "95e3c0b8d4ab42330ef837a1af2118ce5c527d832c3bf1fdb394669347074e11" => :yosemite
    sha256 "b96f9e195121df3ddfeb8f9ee31dbb9570435671dc1e8408002c48eb732e68f4" => :mavericks
  end

  depends_on "go" => :build

  go_resource "gopkg.in/yaml.v2" do
    url "https://gopkg.in/yaml.v2.git",
      :revision => "f7716cbe52baa25d2e9b0d0da546fcf909fc16b4"
  end

  go_resource "github.com/Masterminds/vcs" do
    url "https://github.com/Masterminds/vcs.git",
      :revision => "9c0db6583837118d5df7c2ae38ab1c194e434b35"
  end

  go_resource "github.com/codegangsta/cli" do
    url "https://github.com/codegangsta/cli.git",
      :revision => "c31a7975863e7810c92e2e288a9ab074f9a88f29"
  end

  go_resource "github.com/Masterminds/semver" do
    url "https://github.com/Masterminds/semver.git",
      :revision => "513f3dcb3ecfb1248831fb5cb06a23a3cd5935dc"
  end

  def install

    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/Masterminds/"
    ln_s buildpath, buildpath/"src/github.com/Masterminds/glide"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "glide", "-ldflags", "-X main.version #{version}"
    bin.install "glide"
  end

  test do
    version = pipe_output("#{bin}/glide --version")
    assert_match /#{version}/, version
  end
end
