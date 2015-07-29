class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.ubuntu.com"
  url "https://launchpad.net/juju-core/1.24/1.24.3/+download/juju-core_1.24.3.tar.gz"
  sha256 "edd3054ecfe141760f796292d800d1043d0e0232471a161b3e83be0ac7fde4e7"

  bottle do
    cellar :any
    sha256 "dcd84d22f5db89f5cdb580da7dc1fd3b74182b86412447e09a081b77b864676c" => :yosemite
    sha256 "f233e51247a1a03a7b4547ab16ee6befd3758db7b2be9f1a0214921dcdd4efcf" => :mavericks
    sha256 "75dddcfac10a97017408eb32b7f47b8df413c092a57b28556a4e6e7df1a04ce3" => :mountain_lion
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
