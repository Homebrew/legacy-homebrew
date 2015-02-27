require "language/go"

class Peco < Formula
  homepage "https://github.com/peco/peco"
  url "https://github.com/peco/peco/archive/v0.2.12.tar.gz"
  sha1 "4f5caf6eab2f7c08191939dec7543afc32a6ddde"

  go_resource "github.com/jessevdk/go-flags" do
    url "https://github.com/jessevdk/go-flags.git",
      :revision => "5e118789801496c93ba210d34ef1f2ce5a9173bd"
  end

  go_resource "github.com/mattn/go-runewidth" do
    url "https://github.com/mattn/go-runewidth.git",
      :revision => "c718ccb0685f9fa7129b1b41c04d2877423c419d"
  end

  go_resource "github.com/nsf/termbox-go" do
    url "https://github.com/nsf/termbox-go.git",
      :revision => "1f1918bf12614154995c633122959e84e54ffafa"
  end

  go_resource "github.com/peco/peco" do
    url "https://github.com/peco/peco.git",
      :revision => "f0c506536a5bb4a0e605fb71420690f57087f2d4"
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
