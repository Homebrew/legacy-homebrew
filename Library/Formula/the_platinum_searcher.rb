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
    sha256 "52562cbb714273a6f4904f710219cfbaa9931f3c4bf730243385d7b13f246772" => :yosemite
    sha256 "3a7769aa7ca77e802413af794399de7233d4aef9468ab3caaaf223fd531e76ad" => :mavericks
    sha256 "1a77aac2822772732f24c3e57b67e351110ad580aa07de74b1475168724f2873" => :mountain_lion
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
