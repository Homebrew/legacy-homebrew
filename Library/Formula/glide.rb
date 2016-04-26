require "language/go"

class Glide < Formula
  desc "Simplified Go project management, dependency management, and vendoring"
  homepage "https://github.com/Masterminds/glide"
  url "https://github.com/Masterminds/glide/archive/0.10.1.tar.gz"
  sha256 "092e26f469b06eab7fcdddc315ad328345c0fc1828b640955faa714bfae14371"
  head "https://github.com/Masterminds/glide.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "455a1a4b37a98c8f0effba6f95156da820bd8e3ad2684c4580aedf9ae4e5c6f7" => :el_capitan
    sha256 "854863aaeb250cf921027cd65d2585762dfb9dbef44bd37342bc7d665361347c" => :yosemite
    sha256 "ad28fb93fe560ce34548d709df8a9c07662ec4e87ca69d35d5fde52b6b20091f" => :mavericks
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
