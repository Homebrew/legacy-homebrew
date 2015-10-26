require "language/go"

class Deis < Formula
  desc "Deploy and manage applications on your own servers"
  homepage "http://deis.io"
  url "https://github.com/deis/deis/archive/v1.11.1.tar.gz"
  sha256 "0d5434dbcfcbeaf07e071898ee1d2592cde21422c551a6c87e169474123f6d74"

  bottle do
    cellar :any_skip_relocation
    sha256 "e024e5d2cfed1fcf6a04547ba4a149c943bc81868097185374c7ae5c4f41bea3" => :el_capitan
    sha256 "779e8f88ea17de931f58014e96628c719bc0ff34a60532c7d8b19ede684e253f" => :yosemite
    sha256 "a286d2d1a76f6e9ae0f046b824dd4d4117f39d5833168404ab03be429c0dcd63" => :mavericks
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
