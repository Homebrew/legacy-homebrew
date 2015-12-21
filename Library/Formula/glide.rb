require "language/go"

class Glide < Formula
  desc "Simplified Go project management, dependency management, and vendoring"
  homepage "https://github.com/Masterminds/glide"
  url "https://github.com/Masterminds/glide/archive/0.8.2.tar.gz"
  sha256 "4b4d432632ddbd56624c89738a44589f72d5b097eb9f58ebe41e28900acbc20d"

  bottle do
    cellar :any_skip_relocation
    sha256 "52f1204a2ae05667ef1f64c72934386333bfc5066d58655cdbd47c2ce407435d" => :el_capitan
    sha256 "59af93f467c94e34270b0b49d7686af92bbdeac1d8e82ea5eed36397d2b756e4" => :yosemite
    sha256 "d5e821c77777bf57e9158a0875c47cf6d1f958d5e2a42e6ddfb23b3c2fe5d916" => :mavericks
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
