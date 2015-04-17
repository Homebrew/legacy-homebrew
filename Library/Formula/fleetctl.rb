require "formula"

class Fleetctl < Formula
  homepage "https://github.com/coreos/fleet"
  url "https://github.com/coreos/fleet/archive/v0.10.0.tar.gz"
  sha256 "024b29cb217a81d04a48e6e5017549149fccfe76042a3570e9a3b8206cefcf48"
  head "https://github.com/coreos/fleet.git"

  bottle do
    cellar :any
    sha256 "b352cd97d848738b89f23380d0d4fe837223cac4b2dd035cc78f70f29da5d82c" => :yosemite
    sha256 "3e8166288c032b76828efe9fe822de8e3e3ce0c453ed40dc5fb35fd4fea73743" => :mavericks
    sha256 "0d05a1e3c08bf07c221846681c01e2942da102889dd82141d31387a87781f9be" => :mountain_lion
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "./build"
    bin.install "bin/fleetctl"
  end
end
