require 'formula'

class Juju < Formula
  homepage 'https://juju.ubuntu.com'
  url 'https://launchpad.net/juju-core/1.20/1.20.10/+download/juju-core_1.20.10.tar.gz'
  sha1 '0f59ba487382136f923d9be992d705db3da3e418'

  bottle do
    sha1 "683e051827f984024d87a8d9e55611103c862180" => :mavericks
    sha1 "9dc22987b545b65a787bcebcce55e456b2a1ad2a" => :mountain_lion
    sha1 "bd25350f412c097d907998a5e921c8e1cd233fa0" => :lion
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
