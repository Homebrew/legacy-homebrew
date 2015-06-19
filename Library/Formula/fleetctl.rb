require "formula"

class Fleetctl < Formula
  desc "Distributed init system"
  homepage "https://github.com/coreos/fleet"
  url "https://github.com/coreos/fleet/archive/v0.10.2.tar.gz"
  sha256 "2f5310e8f37c3fbbc0d643a18d27e60c57ba17763a7e6e1e7ad9ae6cb4fe285a"
  head "https://github.com/coreos/fleet.git"

  bottle do
    cellar :any
    sha256 "62982186300220afb27c7723e2f16314a48077d3b4768616c24c70e90304b10a" => :yosemite
    sha256 "b4347fc62257c5280c1b7c5352bd19360e307c4a709501cca25625ff717be051" => :mavericks
    sha256 "8498d6f0fb5557d7dc8ec1ffea50803cbc6e184b230420e8165dbcbd35256c46" => :mountain_lion
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "./build"
    bin.install "bin/fleetctl"
  end
end
