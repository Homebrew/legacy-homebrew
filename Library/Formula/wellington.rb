require "formula"
require "language/go"

class Wellington < Formula
  homepage "https://github.com/wellington/wellington"
  url "https://github.com/wellington/wellington/archive/v0.4.0.tar.gz"
  sha1 "a5aa2866bcb914fd40542089628d5604de85c207"
  head "https://github.com/wellington/wellington.git"

  option :cxx11

  depends_on "go" => :build

  go_resource "github.com/wellington/spritewell" do
    url "http://github.com/wellington/spritewell.git",
      :revision => "3a43f26d94a6da8e40884d1edca0ff372ab7487d"
  end

  #why is this necessary?
  go_resource "github.com/wellington/wellington" do
    url "http://github.com/wellington/wellington.git",
      :revision => "0af6dddfbcef30888e0dde6e68ef8e3ca8e5be0c"
  end

  def install

    ENV["GOPATH"] = buildpath
    system "echo","$GOPATH"
    Language::Go.stage_deps resources, buildpath/"src"

    system "make deps"
    system "go", "build", "-o", "dist/wt", "wt/main.go"
    bin.install "dist/wt"
  end

  test do
    path = testpath/"file.scss"
    path.write "div { p { color: red; } }"
    lines = `#{bin}/wt #{path}`
    assert_equal(`div p {
  color: red; }`, lines)
  end
end
