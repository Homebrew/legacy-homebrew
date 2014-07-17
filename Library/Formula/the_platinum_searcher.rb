require "formula"

class ThePlatinumSearcher < Formula
  homepage "https://github.com/monochromegane/the_platinum_searcher"
  url "https://github.com/monochromegane/the_platinum_searcher/archive/v1.6.5.tar.gz"
  sha1 "51658e4825b5f719fb37072da1b5035b5fde5734"
  head "https://github.com/monochromegane/the_platinum_searcher.git"

  depends_on "go" => :build
  depends_on :hg => :build

  bottle do
    revision 1
    sha1 "9e69bb5e18cacc5f6e4e9fc07ef31bd54a875b08" => :mavericks
    sha1 "2443a197a960177d7a38930f82b209f8e3ce7c56" => :mountain_lion
    sha1 "b97b398a0622bb48f31cf6cfd7905354a223912e" => :lion
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
    path.write "Hello World!"

    lines = `#{bin}/pt 'Hello World!' #{path}`.strip.split(":")
    assert_equal "Hello World!", lines[2]
  end
end
