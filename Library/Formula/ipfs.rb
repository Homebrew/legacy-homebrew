require "language/go"

class Ipfs < Formula
  desc "IPFS is The Permanent Web - A new peer-to-peer hypermedia protocol"
  homepage "http://ipfs.io/"
  url "https://github.com/ipfs/go-ipfs.git",
    :tag => "v0.3.7",
    :revision => "ec51450d071e50464c03a84ef1c3fe3ca902d0e1"
  head "https://github.com/ipfs/go-ipfs.git"

  bottle do
    cellar :any
    sha256 "7fa2048c60b4de4326ebc0e1086ee302f255b9b25c29e16bc596308440f56757" => :yosemite
    sha256 "d12b1c31921d09444bcb0d9781e2c60df69eb1abbe5da5b05ede28ceeb54604c" => :mavericks
    sha256 "02903326215f9ca5d0abfb52d6507b0900baee270d7d78fe6f98c8bd7c7065b2" => :mountain_lion
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
