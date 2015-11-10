require "language/go"

class Glide < Formula
  desc "Simplified Go project management, dependency management, and vendoring"
  homepage "https://github.com/Masterminds/glide"
  url "https://github.com/Masterminds/glide/archive/0.7.1.tar.gz"
  sha256 "a02bb93793b86e6d31d955b4fb1adf0f3a6192d854abca87dc1816055121040f"

  bottle do
    cellar :any_skip_relocation
    sha256 "c445743b3969efa941c08e46e2d74f69b74a29e8fac3ee79d232a43bdbe0c7fd" => :el_capitan
    sha256 "b7ce69bdcdd4ba73c7569bc67b39ebdc856f1aaaa06324896f4cc6e356269301" => :yosemite
    sha256 "5f28acc5f8aba8d90d17e4b71cf8305362c1c647abf89bffbe37d4079b62eff2" => :mavericks
  end

  depends_on "go" => :build

  go_resource "gopkg.in/yaml.v2" do
    url "https://gopkg.in/yaml.v2.git",
      :revision => "53feefa2559fb8dfa8d81baad31be332c97d6c77"
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
      :revision => "70e3fa51ebed95df8c0fbe1519c1c1f9bc16bb13"
  end

  go_resource "github.com/Masterminds/semver" do
    url "https://github.com/Masterminds/semver.git",
      :revision => "6333b7bd29aad1d79898ff568fd90a8aa533ae82"
  end

  def install
    (buildpath + "src/github.com/Masterminds/glide").install "glide.go", "cmd", "gb", "util", "yaml"

    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "glide", "-ldflags", "-X main.version 0.7.1", "#{buildpath}/src/github.com/Masterminds/glide/glide.go"
    bin.install "glide"
  end

  test do
    version = pipe_output("#{bin}/glide --version")
    assert_match /0.7.1/, version
  end
end
