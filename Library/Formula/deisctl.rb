require "language/go"

class Deisctl < Formula
  desc "Deis Control Utility"
  homepage "http://deis.io/"
  url "https://github.com/deis/deis/archive/v1.9.0.tar.gz"
  sha256 "6acca76008b1e48961eb23ddd62f8db742be053983ce34b1a516bb2d4719bf82"

  bottle do
    cellar :any
    sha1 "db686dbc4dc02122cd98a77c74ca2b57ab859fd9" => :yosemite
    sha1 "e4e8d2339df740dd10f8a396eb2d9f7502cfba55" => :mavericks
    sha1 "3effb5512f9ac39b69b639c067a62239b1171677" => :mountain_lion
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
    ENV["CGO_ENABLED"] = "0"
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
