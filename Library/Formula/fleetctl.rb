require "formula"

class Fleetctl < Formula
  homepage "https://github.com/coreos/fleet"
  url "https://github.com/coreos/fleet/archive/v0.10.0.tar.gz"
  sha256 "024b29cb217a81d04a48e6e5017549149fccfe76042a3570e9a3b8206cefcf48"
  head "https://github.com/coreos/fleet.git"

  bottle do
    cellar :any
    sha256 "eab363ee475bb9894e68ee528ba0e2d1a7212c75e3d950315214d847dbabb050" => :yosemite
    sha256 "50db1e44dea50594036dad1dd5b71e181392cd88fc6a233b2a2ccd0ccffee5f7" => :mavericks
    sha256 "7b541eeed582f91e327fdbe9982085a92128de105d3afd05a0bfc5e672daaba7" => :mountain_lion
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "./build"
    bin.install "bin/fleetctl"
  end
end
