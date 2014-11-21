require 'formula'

class Juju < Formula
  homepage 'https://juju.ubuntu.com'
  url 'https://launchpad.net/juju-core/1.20/1.20.13/+download/juju-core_1.20.13.tar.gz'
  sha1 '964c187388b2d5770e43cf875d85805fe44416f7'

  bottle do
    sha1 "bca4470aefb0c273150576597de1ba53e8a53ea0" => :yosemite
    sha1 "8cf42cb143c05cbccaf54ce8d9d8ee0e2b2ec57d" => :mavericks
    sha1 "d2a2db8ce56a10f0d47103dbae81ecbd24217222" => :mountain_lion
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
