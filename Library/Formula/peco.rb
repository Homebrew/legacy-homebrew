require "language/go"

class Peco < Formula
  homepage "https://github.com/peco/peco"
  url "https://github.com/peco/peco/archive/v0.2.12.tar.gz"
  sha1 "4f5caf6eab2f7c08191939dec7543afc32a6ddde"

  bottle do
    cellar :any
    sha1 "c266e3919d01293aedfc7f4ce459be76ccacd954" => :yosemite
    sha1 "9374ae50643d4b8b0e1d09c4b2076e5d3ee09355" => :mavericks
    sha1 "a8e68353239ec1b48866f820b8e3c7915b6b5ec9" => :mountain_lion
  end

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
