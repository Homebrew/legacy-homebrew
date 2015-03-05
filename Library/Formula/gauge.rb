require "language/go"

class Gauge < Formula
  homepage "http://getgauge.io"
  url "https://github.com/getgauge/gauge/archive/v0.0.5.tar.gz"
  sha1 "4f0e51963f40d0a512f8fbd30b12a42d959abc25"

  bottle do
    cellar :any
    sha1 "a719ae5ca2def0f33dd990e7423aea5f750a0315" => :yosemite
    sha1 "eede2a785d3441e07facc69c8efc1f5aedb3b577" => :mavericks
    sha1 "d93d8f4c11e23fc90a67940b9094b81d2170371d" => :mountain_lion
  end

  depends_on "go" => :build

  go_resource "github.com/golang/protobuf" do
    url "https://github.com/golang/protobuf.git",
        :revision => "7f07925444bb51fa4cf9dfe6f7661876f8852275"
  end

  go_resource "github.com/getgauge/common" do
    url "https://github.com/getgauge/common.git",
        :revision => "44ddedf61ebcff8e099aa534616676e43be3ed18"
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
    system "gauge", "--init", "java"
  end
end
