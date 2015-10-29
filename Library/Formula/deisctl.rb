require "language/go"

class Deisctl < Formula
  desc "Deis Control Utility"
  homepage "http://deis.io/"
  url "https://github.com/deis/deis/archive/v1.11.1.tar.gz"
  sha256 "0d5434dbcfcbeaf07e071898ee1d2592cde21422c551a6c87e169474123f6d74"

  bottle do
    cellar :any_skip_relocation
    sha256 "501e7c2a937f32a6b870ef7874dca2aecfd27d1b8642231fd5cf0d7d92e74685" => :el_capitan
    sha256 "780662542e7b73eb2548bb4f614016e47c0dcd63b55991ab7a3c5e3ca2e491f4" => :yosemite
    sha256 "bbbdc491ac6d70aee22d3a64dc97c48decf949adf001af0964ded630d2733533" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/tools/godep" do
    url "https://github.com/tools/godep.git", :revision => "66fa30a455532b64a7f70f8716a274c833bee3c6"
  end

  go_resource "github.com/docopt/docopt-go" do
    url "https://github.com/docopt/docopt-go.git", :revision => "854c423c810880e30b9fecdabb12d54f4a92f9bb"
  end

  go_resource "github.com/coreos/go-etcd" do
    url "https://github.com/coreos/go-etcd.git", :revision => "c904d7032a70da6551c43929f199244f6a45f4c1"
  end

  go_resource "github.com/coreos/fleet" do
    url "https://github.com/coreos/fleet.git", :tag => "v0.9.2", :revision => "e0f7a2316dc6ae610979598c4efe127ac8ff1ae9"
  end

  go_resource "github.com/ugorji/go" do
    url "https://github.com/ugorji/go.git", :revision => "821cda7e48749cacf7cad2c6ed01e96457ca7e9d"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV.prepend_create_path "PATH", buildpath/"bin"

    mkdir_p "#{buildpath}/deisctl/Godeps/_workspace/src/github.com/deis"
    ln_s buildpath, "#{buildpath}/deisctl/Godeps/_workspace/src/github.com/deis/deis"

    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/tools/godep" do
      system "go", "install"
    end

    cd "deisctl" do
      system "godep", "go", "build", "-a", "-ldflags", "-s", "-o", "dist/deisctl"
      bin.install "dist/deisctl"
    end
  end

  test do
    system bin/"deisctl", "help"
  end
end
