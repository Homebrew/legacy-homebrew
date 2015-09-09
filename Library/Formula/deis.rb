require "language/go"

class Deis < Formula
  desc "Deploy and manage applications on your own servers"
  homepage "http://deis.io"
  url "https://github.com/deis/deis/archive/v1.10.0.tar.gz"
  sha256 "afdb0ae576a9c05af2e634a3ac83df9bae99cef17cfd2f1e2c8b7713107e769b"

  bottle do
    cellar :any
    sha256 "fec83c5afc3261b56fccb415ae89588b1cde6828a007af0495b22f7cfbc93195" => :yosemite
    sha256 "eb491d5b606955a10c0dfd916d61964e1a7b2447556b86b2928f977ba7036a0f" => :mavericks
    sha256 "e357da38990b1e9cfd4ee3ad9577b8fa2c0e029752b0705d0bcaf6b9a14d899a" => :mountain_lion
  end

  depends_on "go" => :build

  go_resource "github.com/tools/godep" do
    url "https://github.com/tools/godep.git", :revision => "dd8d14d5985f95e87948edfe1038f0b752bacbef"
  end

  go_resource "github.com/docopt/docopt-go" do
    url "https://github.com/docopt/docopt-go.git", :revision => "854c423c810880e30b9fecdabb12d54f4a92f9bb"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git", :revision => "aedad9a179ec1ea11b7064c57cbc6dc30d7724ec"
  end

  go_resource "gopkg.in/yaml.v2" do
    url "https://github.com/go-yaml/yaml.git", :revision => "7ad95dd0798a40da1ccdff6dff35fd177b5edf40"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV.prepend_create_path "PATH", buildpath/"bin"

    mkdir_p "#{buildpath}/client/Godeps/_workspace/src/github.com/deis"
    ln_s buildpath, "#{buildpath}/client/Godeps/_workspace/src/github.com/deis/deis"

    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/tools/godep" do
      system "go", "install"
    end

    cd "client" do
      system "godep", "go", "build", "-a", "-ldflags", "-s", "-o", "dist/deis"
      bin.install "dist/deis"
    end
  end

  test do
    system "#{bin}/deis", "logout"
  end
end
