class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.ubuntu.com"
  url "https://launchpad.net/juju-core/1.24/1.24.0/+download/juju-core_1.24.0.tar.gz"
  sha256 "1771c016278e73cf7417d9b10f4dbd4f4ea8c05f31753ff5ce2a352beeee03ce"

  bottle do
    cellar :any
    sha256 "a38838ba6c92c5c26fc36381d7e6e62fdee9bd4ac0d0d4a6e8e2b37f31dbad0f" => :yosemite
    sha256 "37ecbd6fa21933d12984b947c5db77d0d6a2efa9722cda2b729d12807baab23c" => :mavericks
    sha256 "83fc63f22eab55c8e4f68e9f8588c30461fee4a26277f0b98c561b44122beca7" => :mountain_lion
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
