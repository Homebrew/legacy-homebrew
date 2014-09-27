require 'formula'

class Juju < Formula
  homepage 'https://juju.ubuntu.com'
  url 'https://launchpad.net/juju-core/1.20/1.20.8/+download/juju-core_1.20.8.tar.gz'
  sha1 '9ca2d865e3051f05888c5aefff1d3f269294359e'

  bottle do
    sha1 "2c8def45af033c81187225a9203071e59dcc738b" => :mavericks
    sha1 "bbd64e1fd23b0d08223a10a8192cee70f0391609" => :mountain_lion
    sha1 "b77f85bf2abad32c8db4ba5d4013158385032153" => :lion
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
