require "language/go"

class Vultr < Formula
  desc "Command-line tool for Vultr"
  homepage "https://jamesclonk.github.io/vultr"
  url "https://github.com/JamesClonk/vultr/archive/v1.6.tar.gz"
  sha256 "b2dcd10704885687d84d118ebc5bdb75f2a6ab0aef654cc018929535ccf2f7ce"

  head "https://github.com/JamesClonk/vultr.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f0b73727573ff08f1a58b7986baea86e9854157bd3b0865ff07b5f1c6aa5a16e" => :el_capitan
    sha256 "19780cdb29dcc0314b4af575a26c0a71d32a3c62981a704fbc35fa4fb91089e4" => :yosemite
    sha256 "c3c147947ea6e6fcf092bc8b9e59d902f6dcb63c4e88b001b1f8cfa040b76636" => :mavericks
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
