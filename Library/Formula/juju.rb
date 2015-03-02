require 'formula'

class Juju < Formula
  homepage 'https://juju.ubuntu.com'
  url 'https://launchpad.net/juju-core/1.21/1.21.3/+download/juju-core_1.21.3.tar.gz'
  sha1 'c5387793e050058695d918a1f7b16736574680d3'

  bottle do
    cellar :any
    sha1 "69e90143d53a747eb7c8193ff54345746d11ad14" => :yosemite
    sha1 "c33cb40f909a83602a28ab0679342fd8b43a666e" => :mavericks
    sha1 "0646b1900de413084965e8fbfb4bbe03f55e0762" => :mountain_lion
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
