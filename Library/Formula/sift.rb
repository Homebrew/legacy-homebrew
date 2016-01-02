require "language/go"

class Sift < Formula
  desc "Fast and powerful open source alternative to grep"
  homepage "https://sift-tool.org"
  url "https://github.com/svent/sift/archive/v0.5.0.tar.gz"
  sha256 "efa1877761e6c86a5ef04548923f9f99bc7a8bacd54fe8926c3b74900bf72e20"

  bottle do
    cellar :any_skip_relocation
    sha256 "0d670eb492a2952e8f60543e15a4b455e4f40172264c37c1debd6efa1e32eeae" => :el_capitan
    sha256 "574e63c3e1c6e305b0eb16caa1687c714f7adec49c03f5674a6f2bec473df545" => :yosemite
    sha256 "35635bc5fc7563a59200c95d003bd61505ae740b623ba9102868fcc427a3d47c" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/svent/go-flags" do
    url "https://github.com/svent/go-flags.git", :revision => "4bcbad344f0318adaf7aabc16929701459009aa3"
  end

  go_resource "github.com/svent/go-nbreader" do
    url "https://github.com/svent/go-nbreader.git", :revision => "7cef48da76dca6a496faa7fe63e39ed665cbd219"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git", :revision => "7b85b097bf7527677d54d3220065e966a0e3b613"
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
