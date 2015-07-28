class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.ubuntu.com"
  url "https://launchpad.net/juju-core/1.24/1.24.3/+download/juju-core_1.24.3.tar.gz"
  sha256 "edd3054ecfe141760f796292d800d1043d0e0232471a161b3e83be0ac7fde4e7"

  bottle do
    cellar :any
    sha256 "54502ad46b72e21de792e1aa5d98fcb154f2b4a6800c46d51f63e09eff2305e0" => :yosemite
    sha256 "9b8e2a36eda728ad160b832d68b144f84f4de091c79ee6b14260ab298ea0b6e2" => :mavericks
    sha256 "d70d809f712e43906de3cf04112043017816d0c4e787e4f95bbdd8c6776d3743" => :mountain_lion
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
