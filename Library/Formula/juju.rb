require 'formula'

class Juju < Formula
  homepage 'https://juju.ubuntu.com'
  url 'https://launchpad.net/juju-core/1.20/1.20.10/+download/juju-core_1.20.10.tar.gz'
  sha1 '0f59ba487382136f923d9be992d705db3da3e418'

  bottle do
    sha1 "cd7f15cfcba77c2be1f1fcf30f6f83e11fb37637" => :mavericks
    sha1 "bdba39a1637540f70e214cbd9edc2bda6b74f2bd" => :mountain_lion
    sha1 "36f3bfa3228abf7645270e3e4a59c6279d1f8158" => :lion
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
