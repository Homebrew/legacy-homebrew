require "language/go"

class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "http://getgauge.io"
  url "https://github.com/getgauge/gauge/archive/v0.3.0.tar.gz"
  sha256 "83257f2e71385ff7cf4480f2ea83af4d99cbc08a52af1c0ccaa043852f4dcd78"

  stable do
    go_resource "github.com/getgauge/common" do
      url "https://github.com/getgauge/common.git",
          :revision => "6d719362535ada9a07d655b65f8bd5dfd818fe33"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d5d14ee930390c3f21152d7308bbbbdb5e0194b7bc653e0d38f173a5ecaf7c8b" => :el_capitan
    sha256 "dd8ee92e5f60e8794a70641cfd79346693467e8a3c175205ef7ea7bdee6763cd" => :yosemite
    sha256 "10ea87a88cd1ea8b74b6b4e7cc459e1af2387e6d3ade01329ac72be05a368ecd" => :mavericks
  end

  head do
    url "https://github.com/getgauge/gauge.git"

    go_resource "github.com/getgauge/common" do
      url "https://github.com/getgauge/common.git",
          :revision => "6d719362535ada9a07d655b65f8bd5dfd818fe33"
    end

  end

  depends_on "go" => :build

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
