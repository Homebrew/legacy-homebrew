require "language/go"

class ThePlatinumSearcher < Formula
  homepage "https://github.com/monochromegane/the_platinum_searcher"
  url "https://github.com/monochromegane/the_platinum_searcher/archive/v1.7.6.tar.gz"
  sha256 "7c7249f88eab09b8f1b89aad2987dc5e23b8ae0df73390150ae9a8a77df346e2"
  head "https://github.com/monochromegane/the_platinum_searcher.git"

  depends_on "go" => :build

  go_resource "github.com/jessevdk/go-flags" do
    url "https://github.com/jessevdk/go-flags.git",
        :revision => "5e118789801496c93ba210d34ef1f2ce5a9173bd"
  end

  go_resource "github.com/monochromegane/terminal" do
    url "https://github.com/monochromegane/terminal.git",
        :revision => "6d255869fb99937f1f287bd1fe3a034c6c4f68f6"
  end

  go_resource "github.com/shiena/ansicolor" do
    url "https://github.com/shiena/ansicolor.git",
        :revision => "8368d3b31cf6f2c2464c7a91675342c9a0ac6658"
  end

  go_resource "golang.org/x/text" do
    url "https://github.com/golang/text.git",
        :revision => "6c3b324efd553c7d76e4da4ed671de76c6bbc791"
  end

  bottle do
    cellar :any
    sha1 "a7a984c9716c0cae11b37cc99724cdb7004058ca" => :yosemite
    sha1 "8ad4be8eb22d125ce6b448e4999dc4bdc1b89cdb" => :mavericks
    sha1 "c0ace5f1aeab2d6eb1f283f676fdc820f5aaa00a" => :mountain_lion
  end

  def install
    # configure buildpath for local dependencies
    mkdir_p buildpath/"src/github.com/monochromegane"
    ln_s buildpath, buildpath/"src/github.com/monochromegane/the_platinum_searcher"

    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", bin/"pt", "cmd/pt/main.go"
  end

  test do
    path = testpath/"hello_world.txt"
    path.write "Hello World!"

    lines = `#{bin}/pt 'Hello World!' #{path}`.strip.split(":")
    assert_equal "Hello World!", lines[2]
  end
end
