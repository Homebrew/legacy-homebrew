require 'formula'

class Juju < Formula
  homepage 'https://juju.ubuntu.com'
  url 'https://launchpad.net/juju-core/1.21/1.21.1/+download/juju-core_1.21.1.tar.gz'
  sha1 '760281b70c33b6f7fd2c24525d9a892a3deec5df'

  bottle do
    cellar :any
    sha1 "fd2f07e8df8cb63c19121e6f73cce7dda8e3a72d" => :yosemite
    sha1 "ff71ae1fe7c28eb0e13e65f917123b7214e23d16" => :mavericks
    sha1 "81eabb39070e65f598382e3aa9dda43eacd1c8be" => :mountain_lion
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
