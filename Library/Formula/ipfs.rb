require "language/go"

class Ipfs < Formula
  desc "IPFS is The Permanent Web - A new peer-to-peer hypermedia protocol"
  homepage "https://ipfs.io/"
  url "https://github.com/ipfs/go-ipfs.git",
    :tag => "v0.3.9",
    :revision => "43622bd5eed1f62d53d364dc771bbb500939d9e6"
  head "https://github.com/ipfs/go-ipfs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9d3d463079b2d32ab5c70c8a314e2aadd3cbe8c72071eb12fbe47f6302b1df57" => :el_capitan
    sha256 "d29aa282f4beda50735bf40e42ce715e5776fd904bd908001ee93999fa3b3c11" => :yosemite
    sha256 "133a939cf59e7114e2be8934bda3601a4697d24abb1b2e6cc864afa8cb7579f3" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/tools/godep" do
    url "https://github.com/tools/godep.git",
      :revision => "5598a9815350896a2cdf9f4f1d0a3003ab9677fb"
  end

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
