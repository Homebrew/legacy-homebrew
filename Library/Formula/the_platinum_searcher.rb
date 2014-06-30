require "formula"

class ThePlatinumSearcher < Formula
  homepage "https://github.com/monochromegane/the_platinum_searcher"
  url "https://github.com/monochromegane/the_platinum_searcher/archive/v1.6.4.tar.gz"
  sha1 "362df20068c9ea19dfb3126c267012356dc7958c"
  head "https://github.com/monochromegane/the_platinum_searcher.git"

  depends_on "go" => :build
  depends_on :hg => :build

  bottle do
    sha1 "ea198486a8ae7d8fcb4990981aee01b6867e7311" => :mavericks
    sha1 "f71a8d2dcb9573d1202b2c2493230d5d0ab383ab" => :mountain_lion
    sha1 "bfdc5095cfbf3e38ca7900b3fb5dad1ec10f089d" => :lion
  end

  def install
    (buildpath + "src/github.com/monochromegane/the_platinum_searcher").install "search"

    ENV["GOPATH"] = buildpath

    system "go", "get", "github.com/shiena/ansicolor"
    system "go", "get", "github.com/monochromegane/terminal"
    system "go", "get", "github.com/jessevdk/go-flags"
    system "go", "get", "code.google.com/p/go.text/transform"

    system "go", "build", "-o", "pt"
    bin.install "pt"
  end

  test do
    path = testpath/"hello_world.txt"
    data = "Hello World!"
    path.open("wb") { |f| f.write data}

    lines = `#{bin}/pt 'Hello World!' #{path}`.strip.split(":")
    assert_equal "Hello World!", lines[2]
  end
end
