require "formula"

class Fleetctl < Formula
  desc "Distributed init system"
  homepage "https://github.com/coreos/fleet"
  url "https://github.com/coreos/fleet/archive/v0.11.2.tar.gz"
  sha256 "85aa7c30b835b0145efe67b1cb4ecc3236d625a120a1b5c75b22feb3ca06f818"
  head "https://github.com/coreos/fleet.git"

  bottle do
    cellar :any
    sha256 "87c6c37fbcc703cb6853015a7b0c4b49c2ee6a18cf31d3604bb81d09d3962dde" => :yosemite
    sha256 "491a50a3f711f6c9e860d87d0ddb4990cae5f8dcfc27270ee4b9194e0a44f49d" => :mavericks
    sha256 "5f63fbb91194db4699f842175d112e84af199d166a910e00ab57558b8d258bd7" => :mountain_lion
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "./build"
    bin.install "bin/fleetctl"
  end
end
