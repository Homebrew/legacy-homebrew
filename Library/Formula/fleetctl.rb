require "formula"

class Fleetctl < Formula
  homepage "https://github.com/coreos/fleet"
  url "https://github.com/coreos/fleet/archive/v0.9.0.tar.gz"
  sha1 "989d5c076b1268e596773ae8ed0d1959d7dabf84"
  head "https://github.com/coreos/fleet.git"

  bottle do
    sha1 "9c19743e0bc3457147b72d66ee9162e0a9a6e3da" => :yosemite
    sha1 "99e7396f5bbf76ef18f917592edb5cd10bc5cf27" => :mavericks
    sha1 "48fa5e33e2805a0a76a8a341085bae8ea40dc4c7" => :mountain_lion
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "./build"
    bin.install "bin/fleetctl"
  end
end
