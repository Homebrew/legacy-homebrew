class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.ubuntu.com"
  url "https://launchpad.net/juju-core/1.24/1.24.0/+download/juju-core_1.24.0.tar.gz"
  sha256 "1771c016278e73cf7417d9b10f4dbd4f4ea8c05f31753ff5ce2a352beeee03ce"

  bottle do
    cellar :any
    sha256 "bfe6b99af8c2906b8e79ad8002c5e9a329a586242d7ccfb32dafaa73ab069c2c" => :yosemite
    sha256 "c68d08219d45cbde861e7c1e0a55198bbdc0898b0f7569be05683925ed0c2f8a" => :mavericks
    sha256 "293d85ce76af44b9a09a91f7ab60ff85413eac98c774edb5a3195303e29ba4f7" => :mountain_lion
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
