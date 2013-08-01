require 'formula'

class Juju < Formula
  homepage 'https://juju.ubuntu.com'
  url "https://launchpad.net/juju-core/1.12/1.12.0/+download/juju-core_1.12.0-1.tar.gz"
  version "1.12.0-1"
  sha1 "b552919f5f4ed5a34885a2a6a8a4a0d7be485267"

  depends_on 'go' => :build

  def install
    ENV['GOPATH'] = buildpath
    args = %w(install launchpad.net/juju-core/cmd/juju)
    args.insert(1, "-v") if ARGV.verbose?
    system "go", *args
    bin.install 'bin/juju'
  end

  def test
    system "#{bin}/juju", "version"
  end
end
