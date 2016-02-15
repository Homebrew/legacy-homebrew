require "language/go"

class Sift < Formula
  desc "Fast and powerful open source alternative to grep"
  homepage "https://sift-tool.org"
  url "https://github.com/svent/sift/archive/v0.8.0.tar.gz"
  sha256 "8686e560771392dde526b12b684015c5b1ca52089119011342f8073513c40751"

  bottle do
    cellar :any_skip_relocation
    sha256 "2e96a45216a604a6d6b7cd69857c2b9ff467026ce79c4f64e200c04f36d74e06" => :el_capitan
    sha256 "7becb81421cfa949e0d8c4d9595e730aefe129324d286f9e2a1a1a8eb8d4d26b" => :yosemite
    sha256 "d8985473aca2ec8f7cd519fe49b13937948357ac2f690a014b9bd8e005d0c9cc" => :mavericks
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
