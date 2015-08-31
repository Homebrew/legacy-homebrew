require "language/go"

class Glide < Formula
  desc "Simplified Go project management, dependency management, and vendoring"
  homepage "https://github.com/Masterminds/glide"
  url "https://github.com/Masterminds/glide/archive/0.5.1.tar.gz"
  sha256 "b7dd696690cee45f505cfab9652602208d6da6e5453213a5ac14b82d1b968628"

  bottle do
    cellar :any
    sha256 "f3292edfc5d96f71fa7f6aaee1f343151a9978d7ec58a7adfcfa3929c52bd2e4" => :yosemite
    sha256 "5e8aa793ac5d1dcea1fa2fb67e438469ad99136cca937da3722dd936cb70db18" => :mavericks
    sha256 "709c25dbc7966b6ff58f4511e5a06839fb77c8456c014a00b8ed93fd2f6325e8" => :mountain_lion
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
      :revision => "5eb2d6a13243848441718e349b5ce6542db01685"
  end

  go_resource "github.com/codegangsta/cli" do
    url "https://github.com/codegangsta/cli.git",
      :revision => "142e6cd241a4dfbf7f07a018f1f8225180018da4"
  end

  def install
    (buildpath + "src/github.com/Masterminds/glide").install "glide.go", "cmd"

    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "glide", "-ldflags", "-X main.version 0.5.1", "#{buildpath}/src/github.com/Masterminds/glide/glide.go"
    bin.install "glide"
  end

  test do
    version = pipe_output("#{bin}/glide --version")
    assert_match /0.5.1/, version
  end
end
