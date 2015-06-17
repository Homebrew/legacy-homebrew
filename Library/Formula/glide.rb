require "formula"
require "language/go"

class Glide < Formula
  desc "Simplified Go project management, dependency management, and vendoring"
  homepage "https://github.com/Masterminds/glide"
  url "https://github.com/Masterminds/glide/archive/0.3.0.tar.gz"
  sha1 "60fb5978446bae925158b594dbf2e15546fd3168"

  bottle do
    sha1 "dea3d205ecbfa38f7cfe5e2b79c5ab12af462df9" => :mavericks
    sha1 "d622cfb237b2e26a63a923f00c7d0af639974219" => :mountain_lion
    sha1 "7afcc2e6b089b38d8ed38979621fceb457df0cfa" => :lion
  end

  depends_on "go" => :build

  go_resource "github.com/kylelemons/go-gypsy" do
    url "https://github.com/kylelemons/go-gypsy.git",
      :revision => "42fc2c7ee9b8bd0ff636cd2d7a8c0a49491044c5"
  end

  go_resource "github.com/Masterminds/cookoo" do
    url "https://github.com/Masterminds/cookoo.git",
      :revision => "623f8762b2474f1ad6c2cac6bf331b8871591379"
  end

  go_resource "github.com/codegangsta/cli" do
    url "https://github.com/codegangsta/cli.git",
      :revision => "7ad88c27405eca0bb4a04bb45897fb7985bd1217"
  end

  def install
    (buildpath + "src/github.com/Masterminds/glide").install "glide.go", "cmd"

    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "glide", "-ldflags", "-X main.version 0.3.0", "#{buildpath}/src/github.com/Masterminds/glide/glide.go"
    bin.install "glide"
  end

  test do
    version = pipe_output("#{bin}/glide --version")
    assert_match /0.3.0/, version
  end
end
