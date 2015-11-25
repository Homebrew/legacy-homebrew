require "language/go"

class Ipfs < Formula
  desc "IPFS is The Permanent Web - A new peer-to-peer hypermedia protocol"
  homepage "http://ipfs.io/"
  url "https://github.com/ipfs/go-ipfs.git",
    :tag => "v0.3.7",
    :revision => "ec51450d071e50464c03a84ef1c3fe3ca902d0e1"
  head "https://github.com/ipfs/go-ipfs.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "02ba7f03c7ae2d4540f35ed09f216d3e191595e9fbca8dd8100cf89aac605104" => :el_capitan
    sha256 "1cc7dd74d1b26a5076e23c40f9cf834ecdc33045fe50846527dfa26f4cfaee9d" => :yosemite
    sha256 "4294823203d142dd54fe86b2f48f5a7c570ec89dcdc1b8658bdd51967a739664" => :mavericks
  end

  depends_on "go" => :build
  depends_on "godep" => :build

   go_resource"github.com/tools/godep" do
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

    cd "cmd/ipfs" do
      system "make", "build"
      bin.install "ipfs"
    end
  end

  test do
    system "#{bin}/ipfs", "version"
  end
end
