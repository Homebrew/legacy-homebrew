require "formula"

class Fleetctl < Formula
  homepage "https://github.com/coreos/fleet"
  url "https://github.com/coreos/fleet/archive/v0.8.3.tar.gz"
  sha1 "0b161574531ffea16453e577a6cd038bf9a85161"
  head "https://github.com/coreos/fleet.git"

  bottle do
    sha1 "d17dde932a893f201d0a7423b28746618fea2d93" => :mavericks
    sha1 "6939ab28d670fa4f6f7860fde26e57bc050c57e2" => :mountain_lion
    sha1 "677db0da4e2e60059e83406b6704342c0730d577" => :lion
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "./build"
    bin.install "bin/fleetctl"
  end
end
