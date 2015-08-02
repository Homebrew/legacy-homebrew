require "formula"

class Fleetctl < Formula
  desc "Distributed init system"
  homepage "https://github.com/coreos/fleet"
  url "https://github.com/coreos/fleet/archive/v0.11.2.tar.gz"
  sha256 "85aa7c30b835b0145efe67b1cb4ecc3236d625a120a1b5c75b22feb3ca06f818"
  head "https://github.com/coreos/fleet.git"

  bottle do
    cellar :any
    sha256 "91f0a5233d85307340bd888b5f17cf12e7ad5cb4738f78b3e674acbb5788b30c" => :yosemite
    sha256 "320e782893fc4ce8f1555ced0f2f30c5fea220e8236b398c6556457bb5d61765" => :mavericks
    sha256 "43720a9a4edb6932427b6fbaaed5255c5b79bcf290e797395341eecbf5b96408" => :mountain_lion
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "./build"
    bin.install "bin/fleetctl"
  end
end
