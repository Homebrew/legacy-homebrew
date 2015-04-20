require 'formula'

class Juju < Formula
  homepage 'https://juju.ubuntu.com'
  url 'https://launchpad.net/juju-core/1.22/1.22.1/+download/juju-core_1.22.1.tar.gz'
  sha1 '29c2e5b93095e8f7e5ff1bb617f3bdb57760ad58'

  bottle do
    cellar :any
    sha256 "906ff5eec585e9cb02f89aecef769da89e1e7f8562d4fd164ca01888f9643fd9" => :yosemite
    sha256 "a98d8b543243cebfaf7791e9d916d7e489eb94104e5fb9fa4e4cd61aaa4de11c" => :mavericks
    sha256 "facdb795dcccf8425d0dc4066f4908c6be77184355f04e18849e2732f9627c05" => :mountain_lion
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
