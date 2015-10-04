require "language/go"

class Peco < Formula
  desc "Simplistic interactive filtering tool"
  homepage "https://github.com/peco/peco"
  url "https://github.com/peco/peco/archive/v0.3.4.tar.gz"
  sha256 "48a864ea92dd12356411ac477b3991d48070528f05d5ca5dfff0ad88e874d470"

  head "https://github.com/peco/peco.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d78befdc344dedcfbf20fdae220bf95b191cde92542550612335055002eb90bb" => :el_capitan
    sha256 "e3d3da83f741ee644c1f65788e592820237f41b3ff22c1205ea6377539dd6d42" => :yosemite
    sha256 "61ac23a2cd5348da97dab231a9645c32505d36ff9194d79aa87f58d11de8dde5" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/google/btree" do
    url "https://github.com/google/btree.git",
      :revision => "0c05920fc3d98100a5e3f7fd339865a6e2aaa671"
  end

  go_resource "github.com/jessevdk/go-flags" do
    url "https://github.com/jessevdk/go-flags.git",
      :revision => "8ec9564882e7923e632f012761c81c46dcf5bec1"
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
