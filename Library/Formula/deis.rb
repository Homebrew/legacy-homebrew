require "language/go"

class Deis < Formula
  desc "Deploy and manage applications on your own servers"
  homepage "http://deis.io"
  url "https://github.com/deis/deis/archive/v1.11.1.tar.gz"
  sha256 "0d5434dbcfcbeaf07e071898ee1d2592cde21422c551a6c87e169474123f6d74"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "c62ccd9efa4f93b290b846942c16df504c8546637d24f038c5f2855bb5b992e8" => :el_capitan
    sha256 "5e2a430023e6bc4273fc1054303e5e8e84e822ebefafc16ff686ef67db1882cf" => :yosemite
    sha256 "7e57cf0300d8f31e45129402d9d3137619b2ee34630f4be81a5b33f68229b17d" => :mavericks
  end

  depends_on "go" => :build
  depends_on "godep" => :build

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
    mkdir_p "#{buildpath}/client/Godeps/_workspace/src/github.com/deis"
    ln_s buildpath, "#{buildpath}/client/Godeps/_workspace/src/github.com/deis/deis"

    Language::Go.stage_deps resources, buildpath/"src"

    cd "client" do
      system "godep", "go", "build", "-a", "-ldflags", "-s", "-o", "dist/deis"
      bin.install "dist/deis"
    end
  end

  test do
    system "#{bin}/deis", "logout"
  end
end
