require "language/go"

class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "http://getgauge.io"
  url "https://github.com/getgauge/gauge/archive/v0.3.2.tar.gz"
  sha256 "6ac9f0c5cea6fcce33a6e69f98dc23d70128ae9144759a0695078c93015a80aa"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a49f272891725f85573f70c87ce11dedd2bbe9b868e1c27c9ae9213f9074cbfc" => :el_capitan
    sha256 "35ad85d7b6aeec27adad5b3aa5ea745c9bfd597c912513089a5665fee926e5e7" => :yosemite
    sha256 "35d4318b170ddf1659101a525d5b0e91ac04510584432be7f5d3dd20a18188fa" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/getgauge/common" do
    url "https://github.com/getgauge/common.git",
        :revision => "2c28867db53c862e386b12fb6ac7829e469758ea"
  end

  go_resource "github.com/daviddengcn/go-colortext" do
    url "https://github.com/daviddengcn/go-colortext.git",
      :revision => "3b18c8575a432453d41fdafb340099fff5bba2f7"
  end

  go_resource "github.com/golang/protobuf" do
    url "https://github.com/golang/protobuf.git",
        :revision => "68415e7123da32b07eab49c96d2c4d6158360e9b"
  end

  go_resource "github.com/mattn/go-isatty" do
    url "https://github.com/mattn/go-isatty.git",
        :revision => "56b76bdf51f7708750eac80fa38b952bb9f32639"
  end

  go_resource "github.com/getgauge/mflag" do
    url "https://github.com/getgauge/mflag.git",
        :revision => "d64a28a7abc05602c9e6d9c5a1488ee69f9fcb83"
  end

  go_resource "github.com/op/go-logging" do
    url "https://github.com/op/go-logging.git",
        :revision => "fb0230561a6ba1cab17beb95f1faedc16584fdb8"
  end

  go_resource "golang.org/x/tools" do
    url "https://go.googlesource.com/tools",
        :revision => "2ef5a0d23bc4e07573bb094b97e96c9cd9844fca",
        :using => :git
  end

  go_resource "gopkg.in/natefinch/lumberjack.v2" do
    url "https://gopkg.in/natefinch/lumberjack.v2",
        :revision => "d28785c2f27cd682d872df46ccd8232843629f54",
        :using =>:git
  end

  go_resource "github.com/dmotylev/goproperties" do
    url "https://github.com/dmotylev/goproperties.git",
        :revision => "7cbffbaada472bc302cbaca51c1d5ed2682eb509"
  end

  go_resource "github.com/apoorvam/goterminal" do
    url "https://github.com/apoorvam/goterminal.git",
        :revision => "4d296b6c70d14de84a3ddbddb11a2fba3babd5e6"
  end

  go_resource "gopkg.in/fsnotify.v1" do
    url "https://gopkg.in/fsnotify.v1",
        :revision => "96c060f6a6b7e0d6f75fddd10efeaca3e5d1bcb0",
        :using => :git
  end

  def install
    ENV["GOPATH"] = buildpath
    gauge_path = buildpath/"src/github.com/getgauge"
    mkdir_p gauge_path
    ln_s buildpath, gauge_path/"gauge"
    Language::Go.stage_deps resources, buildpath/"src"

    cd gauge_path/"gauge" do
      system "go", "run", "build/make.go"
      system "go", "run", "build/make.go", "--install", "--prefix", prefix
    end
  end

  test do
    system bin/"gauge", "-v"
  end
end
