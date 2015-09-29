require "language/go"

class Peco < Formula
  desc "Simplistic interactive filtering tool"
  homepage "https://github.com/peco/peco"
  url "https://github.com/peco/peco/archive/v0.3.4.tar.gz"
  sha256 "48a864ea92dd12356411ac477b3991d48070528f05d5ca5dfff0ad88e874d470"

  head "https://github.com/peco/peco.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0041828f4e6581f5d381a2b3c9b35bbfde65b16f12b5b3072e91db008918808f" => :el_capitan
    sha256 "f2132e8e5383140a49f9a6cadfa57b5736230cfbbec5a924a0edcc9a80f9ddfe" => :yosemite
    sha256 "62ff8a3489cbfb5bea9257c56b924bd77c61c272131090b5edf2edffd1d66042" => :mavericks
    sha256 "284f41c4f38f65f580c8c0d43704fdf672e22c56a22895664bb0e08ea6c5204f" => :mountain_lion
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
