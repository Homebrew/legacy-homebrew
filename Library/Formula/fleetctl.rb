require "formula"

class Fleetctl < Formula
  homepage "https://github.com/coreos/fleet"
  url "https://github.com/coreos/fleet/archive/v0.6.1.tar.gz"
  sha1 "2a839172b5801b98994d2fc69cfe691a612a3bce"
  head "https://github.com/coreos/fleet.git"

  bottle do
    sha1 "1ac4f8f58b2d834eabd0c04b241c743a661b6f17" => :mavericks
    sha1 "bb58012719aab5b35b0023d46ca5105da0969e61" => :mountain_lion
    sha1 "c4d16d2949a134c287e624f498511ccd3aa2806b" => :lion
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "./build"
    bin.install "bin/fleetctl"
  end
end
