require 'formula'

class Juju < Formula
  homepage 'https://juju.ubuntu.com'
  url 'https://launchpad.net/juju-core/1.22/1.22.0/+download/juju-core_1.22.0.tar.gz'
  sha1 '3956a29f5742562ebf31417be4c785154b2b0c19'

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
