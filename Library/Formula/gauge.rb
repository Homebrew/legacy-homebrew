require "language/go"

class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "http://getgauge.io"
  url "https://github.com/getgauge/gauge/archive/v0.2.0.tar.gz"
  sha256 "a1a239e3cabb72a0e4dac39c7488381368e5e489fb3a217f19f260ae9ac17ba6"

  bottle do
    cellar :any_skip_relocation
    sha256 "5e7755e563e2bd2ef5335c087ab0a375d3838ded4159fed16541fb7950122221" => :el_capitan
    sha256 "c77b169cb6c4ec60a2eef31ffc02220d3c1a166ffab1a947aa345fe9313c533c" => :yosemite
    sha256 "9ec0534a3bec4d6ab49e9f103be622d174895270c4bf1f7850dbee9b185c75a4" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/golang/protobuf" do
    url "https://github.com/golang/protobuf.git",
        :revision => "7f07925444bb51fa4cf9dfe6f7661876f8852275"
  end

  go_resource "github.com/getgauge/common" do
    url "https://github.com/getgauge/common.git",
        :revision => "35aa6c6d39b8b5ac50482fe687952201cf675a39"
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

  go_resource "github.com/wsxiaoys/terminal" do
    url "https://github.com/wsxiaoys/terminal.git",
        :revision => "9dcaf1d63119a8ac00eef82270eaef08b6aa2328"
  end

  go_resource "gopkg.in/fsnotify.v1" do
    url "https://gopkg.in/fsnotify.v1",
        :revision => "96c060f6a6b7e0d6f75fddd10efeaca3e5d1bcb0",
        :using => :git
  end

  def install
    ENV["GOPATH"] = buildpath
    gaugePath = buildpath/"src/github.com/getgauge"
    mkdir_p gaugePath
    ln_s buildpath, gaugePath/"gauge"
    Language::Go.stage_deps resources, buildpath/"src"

    cd gaugePath/"gauge" do
      system "go", "run", "build/make.go"
      system "go", "run", "build/make.go", "--install", "--prefix", prefix
    end
  end

  test do
    system bin/"gauge", "-v"
  end
end
