require "language/go"

class Peco < Formula
  desc "Simplistic interactive filtering tool"
  homepage "https://github.com/peco/peco"
  url "https://github.com/peco/peco/archive/v0.3.3.tar.gz"
  sha256 "3d30a8788c2c7cf4ac44bc5ad09415b9b6245c6e842e46b4e234cb844e929c84"

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
      :revision => "cc6329d4279e3f025a53a83c397d2339b5705c45"
  end

  go_resource "github.com/jessevdk/go-flags" do
    url "https://github.com/jessevdk/go-flags.git",
      :revision => "1b89bf73cd2c3a911d7b2a279ab085c4a18cf539"
  end

  go_resource "github.com/mattn/go-runewidth" do
    url "https://github.com/mattn/go-runewidth.git",
      :revision => "5890272cd41c5103531cd7b79e428d99c9e97f76"
  end

  go_resource "github.com/nsf/termbox-go" do
    url "https://github.com/nsf/termbox-go.git",
      :revision => "785b5546a97f27460cfbc4c77132a46b90beb834"
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
