require 'formula'

class Fleetctl < Formula
  homepage 'https://github.com/coreos/fleet'
  url 'https://github.com/coreos/fleet/archive/v0.1.4.tar.gz'
  sha1 '57e58a6f32de622b56dddb7604de2e50ea9a0390'
  head 'https://github.com/coreos/fleet.git'

  depends_on 'go' => :build

  def install
    ENV['GOPATH'] = buildpath
    system "./build"
    bin.install 'bin/fleetctl'
  end
end
