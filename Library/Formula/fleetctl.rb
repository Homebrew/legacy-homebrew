require "formula"

class Fleetctl < Formula
  desc "Distributed init system"
  homepage "https://github.com/coreos/fleet"
  url "https://github.com/coreos/fleet/archive/v0.10.1.tar.gz"
  sha256 "395d49fcd506803acb6e6e1d9528072ea7469b66d7d317ffbe45e6fe931a53b6"
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
