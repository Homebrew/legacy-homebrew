require 'formula'

class Juju < Formula
  homepage 'https://juju.ubuntu.com'
  url 'https://launchpad.net/juju-core/1.20/1.20.9/+download/juju-core_1.20.9.tar.gz'
  sha1 '73bf157293c920e8e38525e80754649dd62594e8'

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
