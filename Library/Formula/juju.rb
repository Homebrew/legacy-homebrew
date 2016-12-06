require 'formula'

class Juju < Formula
  homepage 'https://juju.ubuntu.com'

  version "1.12.0-1"
  url "https://launchpad.net/juju-core/1.12/1.12.0/+download/juju-core_1.12.0-1.tar.gz"
  sha1 "b552919f5f4ed5a34885a2a6a8a4a0d7be485267"

  depends_on 'go' => :build

  def install
    ENV['GOPATH'] = buildpath

    system "go", "install", "launchpad.net/juju-core/cmd/juju"
    prefix.install 'bin'
  end

  def caveats
    "You may run \"juju generate-config -w\" to setup a demo Juju environments config at ~/.juju/environments.yaml."
  end

  def test
    system "#{bin}/juju", "version"
  end
end
