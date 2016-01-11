require "language/go"

class Ipfs < Formula
  desc "IPFS is The Permanent Web - A new peer-to-peer hypermedia protocol"
  homepage "https://ipfs.io/"
  url "https://github.com/ipfs/go-ipfs.git",
    :tag => "v0.3.10",
    :revision => "f9dc4c726b770199f4ee64d97775d5fe8122814e"
  head "https://github.com/ipfs/go-ipfs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0f897b4a0d31c8d0e0e66a79cd10a8ae270c7b47ec52cd5e24d729263bae6a4d" => :el_capitan
    sha256 "1929865f63dc44c6bc9e0100e513533377a545a9e7cebc4b016be9af90d1fc77" => :yosemite
    sha256 "f1f68e35dd9494a4f9dda54039aedc6b6450c3ffecd3e937e885af6e89aa156a" => :mavericks
  end

  depends_on "go" => :build
  depends_on "godep" => :build

  go_resource "github.com/kr/fs" do
    url "https://github.com/kr/fs.git",
      :revision => "2788f0dbd16903de03cb8186e5c7d97b69ad387b"
  end

  go_resource "golang.org/x/tools" do
    url "https://go.googlesource.com/tools",
      :using => :git,
      :revision => "d02228d1857b9f49cd0252788516ff5584266eb6"
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
