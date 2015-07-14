require "formula"

class Fleetctl < Formula
  desc "Distributed init system"
  homepage "https://github.com/coreos/fleet"
  url "https://github.com/coreos/fleet/archive/v0.11.1.tar.gz"
  sha256 "65965730f70021988ed869e23d9599a2305f24287f3ac67c2b995b05ef28cbe8"
  head "https://github.com/coreos/fleet.git"

  bottle do
    cellar :any
    sha256 "fd9569cd4defba9154664f29281803fe349b00eb822145333f1c77da340f0c4b" => :yosemite
    sha256 "c90e834545e262bf320f2de1e4cb5ddf47ecf44a0a54ec36aa1cb641b46fd198" => :mavericks
    sha256 "dc0dcbe17ba1d306f20dca802e29b5d8ce5c22b1dc2a933ccd2081e1e3a7d31a" => :mountain_lion
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "./build"
    bin.install "bin/fleetctl"
  end
end
