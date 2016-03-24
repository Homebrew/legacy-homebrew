require "language/go"

class Glide < Formula
  desc "Simplified Go project management, dependency management, and vendoring"
  homepage "https://github.com/Masterminds/glide"
  url "https://github.com/Masterminds/glide/archive/0.10.0.tar.gz"
  sha256 "7696c2d604de7481ae685af4bc11f7c982f8d3d75c65a0ef7810f78cfc1b5f8b"
  head "https://github.com/Masterminds/glide.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "06bf5c68525d75e9eda532b7057d80ba1577cfcdd2e03b0be9e000b8f684e31f" => :el_capitan
    sha256 "6e7ccb46837a75448615ba1c1c30d49121552a73a6735050eac9a6170f6403b8" => :yosemite
    sha256 "b2c626c72cf5a1a58ae351784d66b028a44945752e85da332f674ba86f109a85" => :mavericks
  end

  depends_on "go" => :build

  go_resource "gopkg.in/yaml.v2" do
    url "https://gopkg.in/yaml.v2.git",
      :revision => "a83829b6f1293c91addabc89d0571c246397bbf4"
  end

  go_resource "github.com/Masterminds/vcs" do
    url "https://github.com/Masterminds/vcs.git",
      :revision => "b22ee1673cdd03ef47bb0b422736a7f17ff0648c"
  end

  go_resource "github.com/codegangsta/cli" do
    url "https://github.com/codegangsta/cli.git",
      :revision => "9fec0fad02befc9209347cc6d620e68e1b45f74d"
  end

  go_resource "github.com/Masterminds/semver" do
    url "https://github.com/Masterminds/semver.git",
      :revision => "808ed7761c233af2de3f9729a041d68c62527f3a"
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
