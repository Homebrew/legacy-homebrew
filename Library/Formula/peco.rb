require "language/go"

class Peco < Formula
  desc "Simplistic interactive filtering tool"
  homepage "https://github.com/peco/peco"
  url "https://github.com/peco/peco/archive/v0.3.2.tar.gz"
  sha256 "ce2d617a49a29a010546b6331f7d3288eeab23226fada591b5c65be035b9c693"

  head "https://github.com/peco/peco.git"

  bottle do
    cellar :any
    sha256 "69a0b87dd86fafe7d6d81cc51df811a4273d6b2a7a73fc8ee4d135f544905b5d" => :yosemite
    sha256 "ea4f6411ebb5cd48283340cff402d338a84d47b7b2849a6b2f870e389c9f89e3" => :mavericks
    sha256 "f9bb9eb2d8eb0273652acd4254da956781baadc361064ecf8f6589a465ebc882" => :mountain_lion
  end

  depends_on "go" => :build

  go_resource "github.com/google/btree" do
    url "https://github.com/google/btree.git",
      :revision => "0c05920fc3d98100a5e3f7fd339865a6e2aaa671"
  end

  go_resource "github.com/jessevdk/go-flags" do
    url "https://github.com/jessevdk/go-flags.git",
      :revision => "5e118789801496c93ba210d34ef1f2ce5a9173bd"
  end

  go_resource "github.com/mattn/go-runewidth" do
    url "https://github.com/mattn/go-runewidth.git",
      :revision => "58a0da4ed7b321c9b5dfeffb7e03ee188fae1c60"
  end

  go_resource "github.com/nsf/termbox-go" do
    url "https://github.com/nsf/termbox-go.git",
      :revision => "10f14d7408b64a659b7c694a771f5006952d336c"
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/peco"
    ln_s buildpath, buildpath/"src/github.com/peco/peco"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "cmd/peco/peco.go"
    bin.install "peco"
  end

  test do
    system "#{bin}/peco", "--version"
  end
end
