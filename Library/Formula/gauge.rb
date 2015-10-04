require "language/go"

class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "http://getgauge.io"
  url "https://github.com/getgauge/gauge/archive/v0.1.8.tar.gz"
  sha256 "d554a3909dec284992b3d067e8cfe86c8fa8fa330db81864c78c69d6e0570df4"

  bottle do
    cellar :any_skip_relocation
    sha256 "5cbd4d2d03347dcb576919b22b92e55e76463821412ce2210a72895825e15cff" => :el_capitan
    sha256 "c638364b069a4a6cefa6cd4b10ba16a2f4525a26976c215d2607df5465a231c7" => :yosemite
    sha256 "e78697736e3b633b162ac309c8c6de1c59c0d4419b1856a23e75bc5e837aa198" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/golang/protobuf" do
    url "https://github.com/golang/protobuf.git",
        :revision => "7f07925444bb51fa4cf9dfe6f7661876f8852275"
  end

  go_resource "github.com/getgauge/common" do
    url "https://github.com/getgauge/common.git",
        :revision => "16d1f84d7248590955440a4027cb062c4289a565"
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
    system "gauge", "-v"
  end
end
