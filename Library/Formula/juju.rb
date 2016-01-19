class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.ubuntu.com"
  url "https://launchpad.net/juju-core/1.25/1.25.2/+download/juju-core_1.25.2.tar.gz"
  sha256 "6928b37c816e8e0851d374a16b71d9edabd369a3a8ed9a7239fdcdee3a9909d0"

  bottle do
    cellar :any_skip_relocation
    sha256 "523c11475207da3a18437f995fa2226370d635e6105989ec533bb0498058ef9e" => :el_capitan
    sha256 "510f352322b98ae6468745768335a07785756fc3d5e5feb32e41d0e039ff6c81" => :yosemite
    sha256 "96e9de0170a6fcefae8426949cccce595a1fea14c8f55d0f225f247425943458" => :mavericks
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
