require "formula"

class ThePlatinumSearcher < Formula
  homepage "https://github.com/monochromegane/the_platinum_searcher"
  url "https://github.com/monochromegane/the_platinum_searcher/archive/v1.7.1.tar.gz"
  sha1 "5e2d704e0c0d8380c82e55a30b7d0fc749ab0c55"
  head "https://github.com/monochromegane/the_platinum_searcher.git"

  depends_on "go" => :build
  depends_on :hg => :build

  bottle do
    revision 1
    sha1 "9e69bb5e18cacc5f6e4e9fc07ef31bd54a875b08" => :mavericks
    sha1 "2443a197a960177d7a38930f82b209f8e3ce7c56" => :mountain_lion
    sha1 "b97b398a0622bb48f31cf6cfd7905354a223912e" => :lion
  end

  resource "godep" do
    url "http://bitly-downloads.s3.amazonaws.com/nsq/godep.tar.gz"
    sha1 "396a62055bb5b4eb4f58cffc64b2ac8deafbacac"
  end


  def install
    # godep is only required to build, so don't install it permanently
    buildpath.install resource("godep")

    # configure buildpath for local dependencies
    mkdir_p buildpath/"src/github.com/monochromegane"
    ln_s buildpath, buildpath/"src/github.com/monochromegane/the_platinum_searcher"

    ENV["GOPATH"] = buildpath
    system "#{buildpath}/godep", "restore"
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
