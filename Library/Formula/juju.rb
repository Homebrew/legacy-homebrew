class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.ubuntu.com"
  url "https://launchpad.net/juju-core/1.25/1.25.3/+download/juju-core_1.25.3.tar.gz"
  sha256 "0c6f0f7f29bf657ced69231175f03601cfb8d5de78610c073fa127e8ae5f1512"

  bottle do
    cellar :any_skip_relocation
    sha256 "4fe4cad12684442b2fa26cc2a5a3258a359b1e5a72fe9c9d6532fddb4f1e0bbc" => :el_capitan
    sha256 "fb69f3d68c12c81a242e6e8e89d50cf50269547ddd83a1c072dcc2dae56703a3" => :yosemite
    sha256 "fb0efbe87f759e3a014feb49067590a3c8fd4b002bf41bdaf2547da8a06f7671" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "go", "build", "github.com/juju/juju/cmd/juju"
    system "go", "build", "github.com/juju/juju/cmd/plugins/juju-metadata"
    bin.install "juju", "juju-metadata"
    bash_completion.install "src/github.com/juju/juju/etc/bash_completion.d/juju-core"
  end

  test do
    system "#{bin}/juju", "version"
  end
end
