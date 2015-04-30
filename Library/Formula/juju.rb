require 'formula'

class Juju < Formula
  homepage 'https://juju.ubuntu.com'
  url 'https://launchpad.net/juju-core/1.23/1.23.2/+download/juju-core_1.23.2.tar.gz'
  sha1 '8dcdd1ba016c51a94a1fff000c393423ed704da7'

  bottle do
    cellar :any
    sha256 "986506830f8eec0e88f34d44bdec64df04c71ddf837ef1af53bbdf0a41d61844" => :yosemite
    sha256 "54e5ce0832b220b43055575c73f94703a423fdfca399888ef9f250b133c99c85" => :mavericks
    sha256 "4854036932825c0278d407a6ac1f8831a3cdc3712274e6f199d2fc80d62e8687" => :mountain_lion
  end

  depends_on 'go' => :build

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
