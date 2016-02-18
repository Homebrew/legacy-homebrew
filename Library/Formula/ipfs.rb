require "language/go"

class Ipfs < Formula
  desc "IPFS is The Permanent Web - A new peer-to-peer hypermedia protocol"
  homepage "https://ipfs.io/"
  url "https://github.com/ipfs/go-ipfs.git",
    :tag => "v0.3.11",
    :revision => "7070b4d878baad57dcc8da80080dd293aa46cabd"
  head "https://github.com/ipfs/go-ipfs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3172c0c1a493bea027b89de415cd3341e85f15a0f049756df81870a347771150" => :el_capitan
    sha256 "5efaddf23bc86c918f50c3f3d5a345e157813dd326331afca13b8b9be8ca8dfd" => :yosemite
    sha256 "d08f479fdce8b136181d8c26e50fdd0d9fba759c2c464efc610ffea0353fc81a" => :mavericks
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
    ENV["GO15VENDOREXPERIMENT"] = "0"
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
