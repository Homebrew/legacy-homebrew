require "formula"

class Fleetctl < Formula
  homepage "https://github.com/coreos/fleet"
  url "https://github.com/coreos/fleet/archive/v0.8.1.tar.gz"
  sha1 "f212d106416cea4d7d310bd2c5f0d843d1fa39ef"
  head "https://github.com/coreos/fleet.git"

  bottle do
    sha1 "5837aae02570e3d6d7a609cd87196e28ad86c297" => :mavericks
    sha1 "e129959dd0e59efeb10063eb887de3daa04c3769" => :mountain_lion
    sha1 "c8579d9c95c87f5c14d33a507c1a04c168d7003b" => :lion
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "./build"
    bin.install "bin/fleetctl"
  end
end
