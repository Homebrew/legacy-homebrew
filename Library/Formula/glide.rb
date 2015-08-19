require "language/go"

class Glide < Formula
  desc "Simplified Go project management, dependency management, and vendoring"
  homepage "https://github.com/Masterminds/glide"
  url "https://github.com/Masterminds/glide/archive/0.5.0.tar.gz"
  sha256 "1fc09fe79e81bd59011c46ec42a76b136fb21bccbb3ab2f4fa0f01ef86f4b38c"

  bottle do
    cellar :any
    sha256 "5e3e65765888e4019bc3c78ef34fda831fa5f03439abe723d4319e06a8b1e2c8" => :yosemite
    sha256 "5c53386ab69d241a8d16c473e6ba45f023dfe341f179b5688189d0b2622e4705" => :mavericks
    sha256 "31e21b5ad11dceed8d8c56367ca9f170d5ceeda925f204cac604d59dffc533a0" => :mountain_lion
  end

  depends_on "go" => :build

  go_resource "github.com/kylelemons/go-gypsy" do
    url "https://github.com/kylelemons/go-gypsy.git",
      :revision => "42fc2c7ee9b8bd0ff636cd2d7a8c0a49491044c5"
  end

  go_resource "github.com/Masterminds/cookoo" do
    url "https://github.com/Masterminds/cookoo.git",
      :revision => "043bf3d5fe7ee75f4831986ce3e2108d24fbeda4"
  end

  go_resource "github.com/Masterminds/vcs" do
    url "https://github.com/Masterminds/vcs.git",
      :revision => "c709a4244b817af98a8ecb495ca4ab0b11f27ecd"
  end

  go_resource "github.com/codegangsta/cli" do
    url "https://github.com/codegangsta/cli.git",
      :revision => "142e6cd241a4dfbf7f07a018f1f8225180018da4"
  end

  def install
    (buildpath + "src/github.com/Masterminds/glide").install "glide.go", "cmd"

    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "glide", "-ldflags", "-X main.version 0.5.0", "#{buildpath}/src/github.com/Masterminds/glide/glide.go"
    bin.install "glide"
  end

  test do
    version = pipe_output("#{bin}/glide --version")
    assert_match /0.5.0/, version
  end
end
