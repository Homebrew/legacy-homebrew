require 'formula'

class Fleetctl < Formula
  homepage 'https://github.com/coreos/fleet'
  url 'https://github.com/coreos/fleet/archive/v0.3.0.tar.gz'
  sha1 'fcce42bca624541f890d5ac61c79fd60a0718407'
  head 'https://github.com/coreos/fleet.git'

  depends_on 'go' => :build

  def install
    ENV['GOPATH'] = buildpath
    system "./build"
    bin.install 'bin/fleetctl'
  end
end
