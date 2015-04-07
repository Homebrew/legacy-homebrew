require 'formula'

class Juju < Formula
  homepage 'https://juju.ubuntu.com'
  url 'https://launchpad.net/juju-core/1.22/1.22.1/+download/juju-core_1.22.1.tar.gz'
  sha1 '29c2e5b93095e8f7e5ff1bb617f3bdb57760ad58'

  bottle do
    cellar :any
    sha256 "5f4167035e4ed30e7ae3de73108f31f7e2fbc0175e9e04bda189d4890c5da659" => :yosemite
    sha256 "674fba6555ab27294aa8db26c7dd82f5c9748cee5b0c0f34c4a72a46dd191f53" => :mavericks
    sha256 "b23fdfb963b2b359ea3f3474ddb5acada2be94ea59869ffcda3c3b5ccad47e86" => :mountain_lion
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
