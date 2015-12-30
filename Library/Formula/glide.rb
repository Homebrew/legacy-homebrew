require "language/go"

class Glide < Formula
  desc "Simplified Go project management, dependency management, and vendoring"
  homepage "https://github.com/Masterminds/glide"
  url "https://github.com/Masterminds/glide/archive/0.8.3.tar.gz"
  sha256 "ec8f7c97f84733bc051d18c10fe6e0e12b2e08cd25400e75702c061be01870c0"

  bottle do
    cellar :any_skip_relocation
    sha256 "e5e49bcd75a6c22dbe18a3acfafb8384309243eb9a76e6b0dee51f6a8602a7ff" => :el_capitan
    sha256 "656d7984746db5672a5b0e112ce8ce0b6096b108be40badb4c56e976a3b15f81" => :yosemite
    sha256 "8f355d750b11eaf2fdf43c15b334b6dc654c92ca72d1bc06aceda83923ecf224" => :mavericks
  end

  depends_on "go" => :build

  go_resource "gopkg.in/yaml.v2" do
    url "https://gopkg.in/yaml.v2.git",
      :revision => "f7716cbe52baa25d2e9b0d0da546fcf909fc16b4"
  end

  go_resource "github.com/Masterminds/cookoo" do
    url "https://github.com/Masterminds/cookoo.git",
      :revision => "78aa11ce75e257c51be7ea945edb84cf19c4a6de"
  end

  go_resource "github.com/Masterminds/vcs" do
    url "https://github.com/Masterminds/vcs.git",
      :revision => "eaee272c8fa4514e1572e182faecff5be20e792a"
  end

  go_resource "github.com/codegangsta/cli" do
    url "https://github.com/codegangsta/cli.git",
      :revision => "b5232bb2934f606f9f27a1305f1eea224e8e8b88"
  end

  go_resource "github.com/Masterminds/semver" do
    url "https://github.com/Masterminds/semver.git",
      :revision => "6333b7bd29aad1d79898ff568fd90a8aa533ae82"
  end

  def install
    (buildpath + "src/github.com/Masterminds/glide").install "glide.go", "cfg", "cmd", "dependency", "gb", "msg", "util"

    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "glide", "-ldflags", "-X main.version #{version}", "#{buildpath}/src/github.com/Masterminds/glide/glide.go"
    bin.install "glide"
  end

  test do
    version = pipe_output("#{bin}/glide --version")
    assert_match /#{version}/, version
  end
end
