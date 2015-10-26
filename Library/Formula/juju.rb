class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.ubuntu.com"
  url "https://launchpad.net/juju-core/1.24/1.24.7/+download/juju-core_1.24.7.tar.gz"
  sha256 "ed9b4549602017794bce7a73317071318b6ee7d569f50bdf00bd9b2f8d2e991b"

  bottle do
    cellar :any_skip_relocation
    sha256 "1cd1aec308f49594043cebcd0cee063d0e9ff7dc78c2ec41f5dcc87ab9da8a37" => :el_capitan
    sha256 "1824bbcd4a44eb0d2245c41bbb170b5d800ac3d180426cc733a0c1550697d713" => :yosemite
    sha256 "d347eafa669beb5418c091a6f69e31b347b83328cb86ea5716c03504bb4aea8a" => :mavericks
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
