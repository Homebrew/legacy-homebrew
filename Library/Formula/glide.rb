require "formula"
require "language/go"

class Glide < Formula
  desc "Simplified Go project management, dependency management, and vendoring"
  homepage "https://github.com/Masterminds/glide"
  url "https://github.com/Masterminds/glide/archive/0.3.0.tar.gz"
  sha1 "60fb5978446bae925158b594dbf2e15546fd3168"

  bottle do
    cellar :any
    sha256 "7c4c13ddcf1c045816b74fa3b00ca21ea451adcf6508d6e7984d61e7f90f86bf" => :yosemite
    sha256 "f92d3a48b8283f204455c217aae38a42f36503ca85c728d576dcc267a62a0aba" => :mavericks
    sha256 "0a48ea01a1fd5f4c6f24dc90588edf82200d4c7833befe20a321950426bd7442" => :mountain_lion
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
