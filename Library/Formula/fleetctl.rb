require "formula"

class Fleetctl < Formula
  homepage "https://github.com/coreos/fleet"
  url "https://github.com/coreos/fleet/archive/v0.8.3.tar.gz"
  sha1 "0b161574531ffea16453e577a6cd038bf9a85161"
  head "https://github.com/coreos/fleet.git"

  bottle do
    sha1 "3afa540c1103571a68079e149796ed1928c9794c" => :mavericks
    sha1 "037f051c01a81dc3d58b5fb10c14bcc6fe55ede5" => :mountain_lion
    sha1 "3b49f61e5e500d78dc3568cadb3731a7e2e3588b" => :lion
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "./build"
    bin.install "bin/fleetctl"
  end
end
