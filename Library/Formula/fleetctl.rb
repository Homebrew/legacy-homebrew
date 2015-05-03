require "formula"

class Fleetctl < Formula
  homepage "https://github.com/coreos/fleet"
  url "https://github.com/coreos/fleet/archive/v0.10.1.tar.gz"
  sha256 "395d49fcd506803acb6e6e1d9528072ea7469b66d7d317ffbe45e6fe931a53b6"
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
