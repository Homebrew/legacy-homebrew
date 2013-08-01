require 'formula'

BUILD="1"
SERIES="1.12"
VERSION="1.12.0"

class Juju < Formula
  homepage 'https://launchpad.net/juju-core'

  version "#{VERSION}-#{BUILD}"
  url "https://launchpad.net/juju-core/#{SERIES}/#{VERSION}/+download/juju-core_#{VERSION}-#{BUILD}.tar.gz"
  sha1 "b552919f5f4ed5a34885a2a6a8a4a0d7be485267"

  depends_on 'go' => :build

  def install
    # set GOPATH to current working directory
    ENV['GOPATH']=Dir.pwd

    system "go", "install", "launchpad.net/juju-core/cmd/juju"
    prefix.install(Dir['bin'])
  end

  def caveats
    "You may run \"juju generate-config -w\" to setup a demo Juju environments config at ~/.juju/environments.yaml."
  end

  def test
    system "#{bin}/juju", "version"
  end
end
