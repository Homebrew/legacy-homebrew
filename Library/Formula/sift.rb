require "language/go"

class Sift < Formula
  desc "Fast and powerful open source alternative to grep"
  homepage "https://sift-tool.org"
  url "https://github.com/svent/sift/archive/v0.8.0.tar.gz"
  sha256 "8686e560771392dde526b12b684015c5b1ca52089119011342f8073513c40751"

  bottle do
    cellar :any_skip_relocation
    sha256 "6dae9b20f62d634243e40a2ffd321756fa5012bf5b628ad4ffc65beac336e65a" => :el_capitan
    sha256 "d6d0721dd56ed477a264954305b04c64b948804b1d4e00252613f2ebe35e7ada" => :yosemite
    sha256 "dc900b64ddf7c4b757fe978d45f984dfc26dc51835880efb76662a1bf8573492" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/svent/go-flags" do
    url "https://github.com/svent/go-flags.git",
    :revision => "4bcbad344f0318adaf7aabc16929701459009aa3"
  end

  go_resource "github.com/svent/go-nbreader" do
    url "https://github.com/svent/go-nbreader.git",
    :revision => "7cef48da76dca6a496faa7fe63e39ed665cbd219"
  end

  go_resource "github.com/svent/sift" do
    url "https://github.com/svent/sift.git",
    :revision => "2d175c4137cad933fa40e0af69020bd658ef5fb3"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
    :revision => "1f22c0103821b9390939b6776727195525381532"
  end

  def install
    ENV["GOPATH"] = buildpath

    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", bin/"sift"
  end

  test do
    (testpath/"test.txt").write "where is foo"
    assert_match(/where is foo/, shell_output("#{bin/"sift"} foo #{testpath}"))
  end
end
