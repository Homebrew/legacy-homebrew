require "language/go"

class Glide < Formula
  desc "Simplified Go project management, dependency management, and vendoring"
  homepage "https://github.com/Masterminds/glide"
  url "https://github.com/Masterminds/glide/archive/0.7.2.tar.gz"
  sha256 "368420de355fcce99187b8ccd5bf1025bbfb6ad394efeb0551b6b09911dfb9f3"

  bottle do
    cellar :any_skip_relocation
    sha256 "d763fca5637dc539410670ba14e9a9cc577a47d5316fa0e6191bcf09ced220f4" => :el_capitan
    sha256 "702f859a36258b64170f31dbb259198eb757dcbc9e5db6a06dc3e7e808d42efd" => :yosemite
    sha256 "192f9a7e4af551a25943e6f4e8ad0e5567c3e94937af8c915622b67ff11f0392" => :mavericks
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

    system "go", "build", "-o", "glide", "-ldflags", "-X main.version 0.7.2", "#{buildpath}/src/github.com/Masterminds/glide/glide.go"
    bin.install "glide"
  end

  test do
    version = pipe_output("#{bin}/glide --version")
    assert_match /0.7.2/, version
  end
end
