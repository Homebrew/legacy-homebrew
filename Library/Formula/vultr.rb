require "language/go"

class Vultr < Formula
  desc "Command-line tool for Vultr"
  homepage "https://jamesclonk.github.io/vultr"
  url "https://github.com/JamesClonk/vultr/archive/v1.5.tar.gz"
  sha256 "ca373d2748268b822e4ad5aeeb4ee8150f8c55c2d761e6c2c8913657469dcca5"
  head "https://github.com/JamesClonk/vultr.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6ad75b4be6619e001a53b462cb1a0ecdb3fb7f973ec7d15259c453b7b4a1e5be" => :el_capitan
    sha256 "ea65646bb2eb938867e4089b952029c19fa2fc5f57af73a66a5dabc0e5886d92" => :yosemite
    sha256 "bad9639a37e7b95d6665bfed524b2e2c57389dbe1b20c67f7341494b4bc0a4a0" => :mavericks
  end

  depends_on "go" => :build
  depends_on "godep" => :build

  go_resource "github.com/kr/fs" do
    url "https://github.com/kr/fs.git", :revision => "2788f0dbd16903de03cb8186e5c7d97b69ad387b"
  end

  go_resource "golang.org/x/tools" do
    url "https://github.com/golang/tools.git", :revision => "473fd854f8276c0b22f17fb458aa8f1a0e2cf5f5"
  end

  go_resource "golang.org/x/crypto" do
    url "https://github.com/golang/crypto.git", :revision => "8b27f58b78dbd60e9a26b60b0d908ea642974b6d"
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/JamesClonk/"
    ln_sf buildpath, buildpath/"src/github.com/JamesClonk/vultr"
    Language::Go.stage_deps resources, buildpath/"src"

    system "godep", "go", "build", "-o", "vultr", "."
    bin.install "vultr"
  end

  test do
    system bin/"vultr", "version"
  end
end
