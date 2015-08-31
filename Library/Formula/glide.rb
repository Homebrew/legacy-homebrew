require "language/go"

class Glide < Formula
  desc "Simplified Go project management, dependency management, and vendoring"
  homepage "https://github.com/Masterminds/glide"
  url "https://github.com/Masterminds/glide/archive/0.5.1.tar.gz"
  sha256 "b7dd696690cee45f505cfab9652602208d6da6e5453213a5ac14b82d1b968628"

  bottle do
    cellar :any
    sha256 "475dad34a9fcf00ddaf9ccd1667022e42be65e4d00e24978705f360116d490e9" => :yosemite
    sha256 "3bb1221cb116e2e3c0dca87c0fd995c28b5ea7b938c1a61ef05373919ba6ad30" => :mavericks
    sha256 "f45601929c0d76acb606dc1fec99b0ae560f50e3587d3189a7164e46ba3b54a2" => :mountain_lion
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
