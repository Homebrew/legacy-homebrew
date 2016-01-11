require "language/go"

class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "http://getgauge.io"
  url "https://github.com/getgauge/gauge/archive/v0.2.1.tar.gz"
  sha256 "382378435500d426464cd05c921ae351d46535b443ce775c908d019526943fc3"

  stable do
    go_resource "github.com/getgauge/common" do
      url "https://github.com/getgauge/common.git",
          :revision => "69cd40635244cf13bceac2ef382bb43152464798"
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
          :revision => "581c7b4383ac47872c364a1848fc2e627b4c92cf"
    end

    go_resource "github.com/gosuri/uilive" do
      url "https://github.com/gosuri/uilive.git",
        :revision => "eb9a944a94f38ebcfa43d48bed49e47050c1aa73"
    end

    go_resource "github.com/daviddengcn/go-colortext" do
      url "https://github.com/daviddengcn/go-colortext.git",
        :revision => "3b18c8575a432453d41fdafb340099fff5bba2f7"
    end
  end

  depends_on "go" => :build

  go_resource "github.com/golang/protobuf" do
    url "https://github.com/golang/protobuf.git",
        :revision => "7f07925444bb51fa4cf9dfe6f7661876f8852275"
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
