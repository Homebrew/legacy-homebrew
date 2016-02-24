require "language/go"

class Glide < Formula
  desc "Simplified Go project management, dependency management, and vendoring"
  homepage "https://github.com/Masterminds/glide"
  url "https://github.com/Masterminds/glide/archive/0.9.1.tar.gz"
  sha256 "a865b29d0e48a50eccc1615e440b5b064b351d391567cc5fa26e789617551ebe"
  head "https://github.com/Masterminds/glide.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f8cc5a72aac0bb71d8bd17e0e63696b81b6855b503af8b53bc519b1f2d3de5d9" => :el_capitan
    sha256 "cdc4c069bcd4aecd2f590eb4ad28a0d668c9b89183c9e52d6f5ffd95f745078f" => :yosemite
    sha256 "a143bfbc241b46bb107acaf70ce813f750a3facec0619d3ecb0f52d52ce81514" => :mavericks
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
