require "language/go"

class Peco < Formula
  homepage "https://github.com/peco/peco"
  url "https://github.com/peco/peco/archive/v0.2.11.tar.gz"
  sha1 "438e76dc7f31215eb1195d5eb14a66cf7fef318e"

  bottle do
    cellar :any
    sha1 "09dcbdd0a4cc55c36cc4578f237ac19c360651a1" => :yosemite
    sha1 "eaf5161f6ce66b67a026825a4f3047974d147500" => :mavericks
    sha1 "61e853d89cd34129cf0e010c36939491c3b11329" => :mountain_lion
  end

  go_resource "github.com/jessevdk/go-flags" do
    url "https://github.com/jessevdk/go-flags.git",
      :revision => "15347ef417a300349807983f15af9e65cd2e1b3a"
  end

  go_resource "github.com/mattn/go-runewidth" do
    url "https://github.com/mattn/go-runewidth.git",
      :revision => "8adae32de8a26f36cc7acaa53051407d514bb5f0"
  end

  go_resource "github.com/nsf/termbox-go" do
    url "https://github.com/nsf/termbox-go.git",
      :revision => "9e7f2135126fcf13f331e7b24f5d66fd8e8e1690"
  end

  go_resource "github.com/peco/peco" do
    url "https://github.com/peco/peco.git",
      :revision => "0ad82671a0546fe4cace0eb9787b900bcc77aad0"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "cmd/peco/peco.go"
    bin.install "peco"
  end

  test do
    system "#{bin}/peco", "--version"
  end
end
