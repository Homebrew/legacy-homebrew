require "language/go"

class Jvgrep < Formula
  desc "Grep for Japanese users of Vim"
  homepage "https://github.com/mattn/jvgrep"
  url "https://github.com/mattn/jvgrep/archive/v4.2.tar.gz"
  sha256 "33b7f28ba20489dbd5e90d1b68ad9c5b8c9919632c204ed02f7d2ce6384e59c6"

  head "https://github.com/mattn/jvgrep.git"

  bottle do
    cellar :any
    sha256 "4481c6cdb2281a4f51c2049792ea2ac28dbfa35020157e8853e27933b0ae4583" => :yosemite
    sha256 "ee066a8848a150969807647723de09cea8cc8b8ed38ce31220d058b1e62cc312" => :mavericks
    sha256 "a46b5a7f23dc31bc9df5fcc89fe1618a2a0063dc1a75a466b21059c7a02db386" => :mountain_lion
  end

  depends_on "go" => :build

  go_resource "github.com/daviddengcn/go-colortext" do
    url "https://github.com/daviddengcn/go-colortext.git", :revision => "13eaeb896f5985a1ab74ddea58707a73d875ba57"
  end

  go_resource "github.com/mattn/go-isatty" do
    url "https://github.com/mattn/go-isatty.git", :revision => "ae0b1f8f8004be68d791a576e3d8e7648ab41449"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git", :revision => "a8c61998a557a37435f719980da368469c10bfed"
  end

  go_resource "golang.org/x/text" do
    url "https://go.googlesource.com/text.git", :revision => "af4c2d73d0954e6f7ed1bd89afe33c9d347d9be5"
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/mattn"
    ln_s buildpath, buildpath/"src/github.com/mattn/jvgrep"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "jvgrep.go"
    bin.install "jvgrep"
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    system "#{bin}/jvgrep", "Hello World!", testpath
  end
end
