require "language/go"

class Ipfs < Formula
  desc "IPFS is The Permanent Web - A new peer-to-peer hypermedia protocol"
  homepage "http://ipfs.io/"
  url "https://github.com/ipfs/go-ipfs.git",
    :tag => "v0.3.5",
    :revision => "952dc9c60fdff27902749222fdc30164e7eea1ee"

  bottle do
    cellar :any
    sha256 "99d7c8ec259245c955fd8445ad12876e63664aa7f3511590159ec45450190b0a" => :yosemite
    sha256 "8744b3b05caf0de3c3d3a147a5af0abd856868e95058e1b25f8c79fd75ff89f4" => :mavericks
    sha256 "2b0ca89668c906ed6f3af15e098bf04009695cbc346ef02b363b53acfcc48257" => :mountain_lion
  end

  depends_on "go" => :build

  go_resource "github.com/tools/godep" do
    url "https://github.com/tools/godep.git",
      :revision => "58d90f262c13357d3203e67a33c6f7a9382f9223"
  end

  go_resource "github.com/kr/fs" do
    url "https://github.com/kr/fs.git",
      :revision => "2788f0dbd16903de03cb8186e5c7d97b69ad387b"
  end

  go_resource "golang.org/x/tools" do
    url "https://go.googlesource.com/tools",
      :using => :git,
      :revision => "b1aed1a596ad02d2aa2eb5c5af431a7ba2f6afc4"
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/ipfs/"
    ln_sf buildpath, buildpath/"src/github.com/ipfs/go-ipfs"
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/tools/godep" do
      system "go", "install"
    end

    cd "cmd/ipfs" do
      system "make", "build"
      bin.install "ipfs"
    end
  end

  test do
    system "#{bin}/ipfs", "version"
  end
end
