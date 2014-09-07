require "formula"
require "language/go"

class ThePlatinumSearcher < Formula
  homepage "https://github.com/monochromegane/the_platinum_searcher"
  url "https://github.com/monochromegane/the_platinum_searcher/archive/v1.7.1.tar.gz"
  sha1 "5e2d704e0c0d8380c82e55a30b7d0fc749ab0c55"
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
  depends_on :hg => :build

  bottle do
    revision 1
    sha1 "9e69bb5e18cacc5f6e4e9fc07ef31bd54a875b08" => :mavericks
    sha1 "2443a197a960177d7a38930f82b209f8e3ce7c56" => :mountain_lion
    sha1 "b97b398a0622bb48f31cf6cfd7905354a223912e" => :lion
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
