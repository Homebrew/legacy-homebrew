require "formula"

class Fleetctl < Formula
  homepage "https://github.com/coreos/fleet"
  url "https://github.com/coreos/fleet/archive/v0.7.0.tar.gz"
  sha1 "9bec7868c9eeec59b3d8f28d01c8a631597b6b09"
  head "https://github.com/coreos/fleet.git"

  bottle do
    sha1 "7a68c1ad14596201d8c13259047951bf4c3081c7" => :mavericks
    sha1 "eb2f8ec141aa3d7c6bdd5c81211d1e0777d78f13" => :mountain_lion
    sha1 "057ab92b97d1ec66d6421dd378acf045b6ae3a83" => :lion
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "./build"
    bin.install "bin/fleetctl"
  end
end
