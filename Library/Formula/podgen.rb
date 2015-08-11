require "language/go"

class Podgen < Formula
  desc "Static podcast site generator, especially for itunes podcast."
  homepage "https://github.com/tyrchen/podgen/"
  url "https://github.com/tyrchen/podgen/archive/v0.3.2.tar.gz"
  sha256 "c05c70ae79c437c31cafa0a8d38e7d42636d66d10d804b18480d329eb890e84b"

  head "https://github.com/tyrchen/podgen.git"

  depends_on "go" => :build

  go_resource "github.com/codegangsta/inject" do
    url "https://github.com/codegangsta/inject.git",
      :revision => "33e0aa1cb7c019ccc3fbe049a8262a6403d30504"
  end

  go_resource "github.com/codeskyblue/go-sh" do
    url "https://github.com/codeskyblue/go-sh.git",
      :revision => "3d593d477915b4d2f2e74b2e041495345647a46b"
  end

  go_resource "github.com/inconshreveable/mousetrap" do
    url "https://github.com/inconshreveable/mousetrap.git",
      :revision => "76626ae9c91c4f2a10f34cad8ce83ea42c93bb75"
  end

  go_resource "github.com/satori/go.uuid" do
    url "https://github.com/satori/go.uuid.git",
      :revision => "6b8e5b55d20d01ad47ecfe98e5171688397c61e9"
  end

  go_resource "github.com/skratchdot/open-golang" do
    url "https://github.com/skratchdot/open-golang.git",
      :revision => "c8748311a7528d0ba7330d302adbc5a677ef9c9e"
  end

  go_resource "github.com/spf13/cobra" do
    url "https://github.com/spf13/cobra.git",
      :revision => "c55cdf33856a08e4822738728b41783292812889"
  end

  go_resource "github.com/spf13/pflag" do
    url "https://github.com/spf13/pflag.git",
      :revision => "41e9136667ee4f9ffd03da380e24629d7eccace4"
  end

  go_resource "github.com/tcnksm/go-gitconfig" do
    url "https://github.com/tcnksm/go-gitconfig.git",
      :revision => "6411ba19847f20afe47f603328d97aaeca6def6f"
  end

  go_resource "github.com/tyrchen/gopod" do
    url "https://github.com/tyrchen/gopod.git",
      :revision => "dbb3109380df9637097ad7233e00d7ab957921b0"
  end

  go_resource "gopkg.in/fsnotify.v1" do
    url "https://gopkg.in/fsnotify.v1.git",
      :revision => "96c060f6a6b7e0d6f75fddd10efeaca3e5d1bcb0"
  end

  go_resource "gopkg.in/yaml.v2" do
    url "https://gopkg.in/yaml.v2.git",
      :revision => "7ad95dd0798a40da1ccdff6dff35fd177b5edf40"
  end

  def install
    ENV["GOBIN"] = bin
    ENV["GOPATH"] = buildpath
    ENV["GOHOME"] = buildpath

    mkdir_p buildpath/"src/github.com/tyrchen/"
    ln_sf buildpath, buildpath/"src/github.com/tyrchen/podgen"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", bin/"podgen", "main.go"
  end

  test do
    File.write("items.yml", "")
    system "#{bin}/podgen", "new"
    assert File.open("items.yml").read.length > 0
  end
end

