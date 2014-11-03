require 'formula'

class Juju < Formula
  homepage 'https://juju.ubuntu.com'
  url 'https://launchpad.net/juju-core/1.20/1.20.11/+download/juju-core_1.20.11.tar.gz'
  sha1 'ce76b26648533501ed9e1918abe740116d4de73b'

  bottle do
    sha1 "b7c719dab5385cd52771527ab1f97de174445714" => :yosemite
    sha1 "a7e0ec9697c5055f5bdeefbd76b2579462f949f9" => :mavericks
    sha1 "5032c2e7415d000212b7298a92c84192454c4d9c" => :mountain_lion
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
