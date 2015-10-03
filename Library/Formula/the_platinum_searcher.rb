require "language/go"

class ThePlatinumSearcher < Formula
  desc "Multi-platform code-search similar to ack and ag"
  homepage "https://github.com/monochromegane/the_platinum_searcher"
  url "https://github.com/monochromegane/the_platinum_searcher/archive/v1.7.8.tar.gz"
  sha256 "965f33c1b30d76d083fc425160ec2562acf64fb087dd62ebce510424bee787b8"
  head "https://github.com/monochromegane/the_platinum_searcher.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6a1d8043f8cebab8920e471f6d3e81d7616b44f9cb3c9a489d872198488eb280" => :el_capitan
    sha256 "b54f456ff639feb502bb0d2e26e56d88226df18588617c43be4701cd04a68be7" => :yosemite
    sha256 "a3d438fb5d3caf361b58b482b77d58a72534ed4d91d16194702d35c3790c182a" => :mavericks
    sha256 "66fa09e74f3cb51a3e54623e0a6b4af1fe3cc1b2b010abd62157f7c189f06aec" => :mountain_lion
  end

  depends_on "go" => :build

  go_resource "github.com/jessevdk/go-flags" do
    url "https://github.com/jessevdk/go-flags.git",
        :revision => "1b89bf73cd2c3a911d7b2a279ab085c4a18cf539"
  end

  go_resource "github.com/monochromegane/terminal" do
    url "https://github.com/monochromegane/terminal.git",
        :revision => "6d255869fb99937f1f287bd1fe3a034c6c4f68f6"
  end

  go_resource "github.com/shiena/ansicolor" do
    url "https://github.com/shiena/ansicolor.git",
        :revision => "a5e2b567a4dd6cc74545b8a4f27c9d63b9e7735b"
  end

  go_resource "golang.org/x/text" do
    url "https://github.com/golang/text.git",
        :revision => "3eb7007b740b66a77f3c85f2660a0240b284115a"
  end

  def install
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
