require "language/go"

class Jvgrep < Formula
  homepage "https://github.com/mattn/jvgrep"
  url "https://github.com/mattn/jvgrep/archive/v4.1.tar.gz"
  sha256 "f0d8d4a2214e6873688dfe2f75e21c8c4a0a105efd145cde419abf4280e57fb2"

  head "https://github.com/mattn/jvgrep.git"

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
