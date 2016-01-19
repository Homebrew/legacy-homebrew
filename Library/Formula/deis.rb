require "language/go"

class Deis < Formula
  desc "Deploy and manage applications on your own servers"
  homepage "http://deis.io"
  url "https://github.com/deis/deis/archive/v1.12.2.tar.gz"
  sha256 "48aa8f81697b213bd25e95bc2065f7c0dc75e824d7420e71856e102cc16a5229"

  bottle do
    cellar :any_skip_relocation
    sha256 "cc0e58c2a9c9ccc78682da73ea641a493ab8d3914ca42c1d0a021f23dbebdf16" => :el_capitan
    sha256 "a8c047c7d0713c13707073ccc0907ada267690ca306b6b3626e61274b53028c7" => :yosemite
    sha256 "ea98f93bf5baece7c84767d7150044a41606a590bd881810418376456e11a765" => :mavericks
  end

  depends_on "go" => :build
  depends_on "godep" => :build

  go_resource "github.com/docopt/docopt-go" do
    url "https://github.com/docopt/docopt-go.git",
        :revision => "854c423c810880e30b9fecdabb12d54f4a92f9bb"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
        :revision => "f7445b17d61953e333441674c2d11e91ae4559d3"
  end

  go_resource "gopkg.in/yaml.v2" do
    url "https://github.com/go-yaml/yaml.git",
        :revision => "eca94c41d994ae2215d455ce578ae6e2dc6ee516"
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
