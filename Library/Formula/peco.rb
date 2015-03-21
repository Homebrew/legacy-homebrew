require "language/go"

class Peco < Formula
  homepage "https://github.com/peco/peco"
  url "https://github.com/peco/peco/archive/v0.3.0.tar.gz"
  sha1 "dcecc51e5f62adeb09f2dcb0680b7fb6d1e0c50f"

  bottle do
    cellar :any
    sha256 "16be6e9c7eb32408c68148aa9271025714424d3af6c09f34444f54f12fd95817" => :yosemite
    sha256 "673f42e05938dbfc366498276002342b3fe6de0ccffba8cdb4cbb4a65b4e7a3f" => :mavericks
    sha256 "f71b17c651c0c6c960a88be59e33cc8f11499e4c6d378b020b691e08f3a691a6" => :mountain_lion
  end

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

  go_resource "github.com/peco/peco" do
    url "https://github.com/peco/peco.git",
      :revision => "700b77b5ba57ce0cc57339d063a24bb06a485eca"
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
