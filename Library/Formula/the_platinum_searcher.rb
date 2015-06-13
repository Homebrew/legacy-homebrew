require "language/go"

class ThePlatinumSearcher < Formula
  desc "Multi-platform code-search similar to ack and ag"
  homepage "https://github.com/monochromegane/the_platinum_searcher"
  url "https://github.com/monochromegane/the_platinum_searcher/archive/v1.7.7.tar.gz"
  sha256 "8009fa74e93b26d362f8ddb2354818ce7736b683c1c9afa405022d8efb057d91"
  head "https://github.com/monochromegane/the_platinum_searcher.git"

  depends_on "go" => :build

  go_resource "github.com/jessevdk/go-flags" do
    url "https://github.com/jessevdk/go-flags.git",
        :revision => "1679536dcc895411a9f5848d9a0250be7856448c"
  end

  go_resource "github.com/monochromegane/terminal" do
    url "https://github.com/monochromegane/terminal.git",
        :revision => "6d255869fb99937f1f287bd1fe3a034c6c4f68f6"
  end

  go_resource "github.com/shiena/ansicolor" do
    url "https://github.com/shiena/ansicolor.git",
        :revision => "6046e7d18a7698e98846e5d25842e9cf15aecf2c"
  end

  go_resource "golang.org/x/text" do
    url "https://github.com/golang/text.git",
        :revision => "c980adc4a823548817b9c47d38c6ca6b7d7d8b6a"
  end

  bottle do
    cellar :any
    sha256 "ed9b856da6f6abe519a0751600dd24a5b47c3c486140900d2c16d1bbed8d7e0b" => :yosemite
    sha256 "19a0bc22ab3e0a291982b750f3ca339d36573cef8aeb88fddd3ac2b886cc1085" => :mavericks
    sha256 "6be9cac1ed488a52e9b81434e545f42f87a6422d3772363af7c013c09d8b665b" => :mountain_lion
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
