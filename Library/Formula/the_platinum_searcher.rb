require "formula"
require "language/go"

class ThePlatinumSearcher < Formula
  homepage "https://github.com/monochromegane/the_platinum_searcher"
  url "https://github.com/monochromegane/the_platinum_searcher/archive/v1.7.5.tar.gz"
  sha1 "775f73aaf894dabcfbd80f07eeb0d8450010ac15"
  head "https://github.com/monochromegane/the_platinum_searcher.git"

  go_resource "github.com/jessevdk/go-flags" do
    url "https://github.com/jessevdk/go-flags.git",
      :revision => "7047cf7a8dc6f41e53365420ab62d415055232c6"
  end

  go_resource "github.com/monochromegane/terminal" do
    url "https://github.com/monochromegane/terminal.git",
      :revision => "6d255869fb99937f1f287bd1fe3a034c6c4f68f6"
  end

  go_resource "github.com/shiena/ansicolor" do
    url "https://github.com/shiena/ansicolor.git",
      :revision => "6046e7d18a7698e98846e5d25842e9cf15aecf2c"
  end

  go_resource "code.google.com/p/go.text" do
    url "https://code.google.com/p/go.text", :using => :hg,
      :revision => "46250cb715a27b42c736a5ff2a4e6fa0b2118952"
  end

  depends_on "go" => :build

  bottle do
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

    system "go", "build", "-o", "pt", "cmd/pt/main.go"
    bin.install "pt"
  end

  test do
    path = testpath/"hello_world.txt"
    path.write "Hello World!"

    lines = `#{bin}/pt 'Hello World!' #{path}`.strip.split(":")
    assert_equal "Hello World!", lines[2]
  end
end
