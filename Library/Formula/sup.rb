require "language/go"

class Sup < Formula
  desc "Super simple deployment tool - just Unix - think of it like 'make' for a network of servers."
  homepage "https://github.com/pressly/sup"
  url "https://github.com/pressly/sup/archive/4ee5083c8321340bc2a6410f24d8a760f7ad3847.zip"
  version "0.3.1"
  sha256 "7fa17c20fdcd9e24d8c2fe98081e1300e936da02b3f2cf9c5a11fd699cbc487e"

  depends_on "go"  => :build

  go_resource "github.com/goware/prefixer" do
    url "https://github.com/goware/prefixer.git",
      :revision => "395022866408d928fc2439f7eac73dd8d370ec1d"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
      :revision => "3760e016850398b85094c4c99e955b8c3dea5711"
  end

  go_resource "gopkg.in/yaml.v2" do
    url "https://gopkg.in/yaml.v2.git", :revision => "f7716cbe52baa25d2e9b0d0da546fcf909fc16b4"
  end

  def install
    ENV["GOBIN"] = bin
    ENV["GOPATH"] = buildpath
    ENV["GOHOME"] = buildpath

    mkdir_p buildpath/"src/github.com/pressly/"
    ln_sf buildpath, buildpath/"src/github.com/pressly/sup"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", bin/"sup", "./cmd/sup"
  end

  test do
    assert_equal "0.3", shell_output("#{bin}/bin/sup")
  end
end
