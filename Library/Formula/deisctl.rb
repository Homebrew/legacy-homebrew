require "language/go"

class Deisctl < Formula
  desc "Deis Control Utility"
  homepage "http://deis.io/"
  url "https://github.com/deis/deis/archive/v1.10.0.tar.gz"
  sha256 "afdb0ae576a9c05af2e634a3ac83df9bae99cef17cfd2f1e2c8b7713107e769b"

  bottle do
    cellar :any_skip_relocation
    sha256 "938d5e24e4d5d930f30c79eb3917e20562aaaeee99eae65c96060ab132155a49" => :el_capitan
    sha256 "abe80f8373fb24b67bd926ded9c8fba9878db64e0edc23553a172c81f9c21704" => :yosemite
    sha256 "78708383d85baaf985463a1f3bd3fe44a4b4667149df58e38896ddce724e964c" => :mavericks
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
