require "language/go"

class Gauge < Formula
  homepage "http://getgauge.io"
  url "https://github.com/getgauge/gauge/archive/v0.0.3.tar.gz"
  sha1 "5cb64ce8d803c739c3e21513b334e0d2216cc68a"

  bottle do
    sha1 "6b503ea7ac28bd315a8a7fa55917aaccb20e9e87" => :yosemite
    sha1 "b353b1dc155055ed3b8f94f6f1ebe2e470246c97" => :mavericks
    sha1 "10eacac84c0de5491bea5368bc6d33d65d49a2f4" => :mountain_lion
  end

  depends_on "go" => :build

  go_resource "code.google.com/p/goprotobuf" do
    url "https://code.google.com/p/goprotobuf",
        :revision => "725eb0907b649c438e0e8f1601648597141fb66c",
        :using => :hg
  end

  go_resource "github.com/getgauge/common" do
    url "https://github.com/getgauge/common.git",
        :revision => "4c20d2d8fc5c4c447a6110f4f888f72c3d66f84c"
  end

  go_resource "github.com/getgauge/mflag" do
    url "https://github.com/getgauge/mflag.git",
        :revision => "d64a28a7abc05602c9e6d9c5a1488ee69f9fcb83"
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
