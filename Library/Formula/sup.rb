require "language/go"

class Sup < Formula
  desc "Super simple deployment tool - just Unix - think of it like 'make' for a network of servers."
  homepage "https://github.com/pressly/sup"
  #url "https://github.com/pressly/sup/archive/v0.3.zip"
  url "https://github.com/pressly/sup/archive/4ee5083c8321340bc2a6410f24d8a760f7ad3847.zip"
  sha256 "876c9c2bb8bf71de2889fca97d42da696b31700930dfe84131c133c762ecea45"
  version "0.3.1"

  head do
    url "https://github.com/pressly/sup.git"
  end

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

    system "make build"
    bin.install "bin/sup" => "sup"

    puts "Ready to go! Learn more at https://github.com/pressly/sup"
  end

  test do
    assert File.exist?("/usr/local/bin/sup")
    assert_equal(0, "/usr/local/bin/sup")
  end
end
