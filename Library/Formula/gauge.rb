require "language/go"

class Gauge < Formula
  homepage "http://getgauge.io"
  url "https://github.com/getgauge/gauge/archive/v0.0.4.tar.gz"
  sha1 "d0bbfd4c782bccca5fbf3f8fa9ada71e1723a5eb"

  bottle do
    cellar :any
    sha1 "0408f93bb04533a29662114fb7a6cb823b3d3acb" => :yosemite
    sha1 "130942e5196154996d3589ab0d054af2f5e5d9e9" => :mavericks
    sha1 "324e44c1dc852274a48123760e7bdeb03ce240b6" => :mountain_lion
  end

  depends_on "go" => :build

  go_resource "github.com/golang/protobuf" do
    url "https://github.com/golang/protobuf.git",
        :revision => "7f07925444bb51fa4cf9dfe6f7661876f8852275"
  end

  go_resource "github.com/getgauge/common" do
    url "https://github.com/getgauge/common.git",
        :revision => "a947acc34020882e7a00d6366a66b24ec7f3f578"
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
