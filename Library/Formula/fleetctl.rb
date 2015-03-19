require "formula"

class Fleetctl < Formula
  homepage "https://github.com/coreos/fleet"
  url "https://github.com/coreos/fleet/archive/v0.9.1.tar.gz"
  sha1 "1e3754c9be085634f1d637f3ba737147c6f4bab2"
  head "https://github.com/coreos/fleet.git"

  bottle do
    cellar :any
    sha1 "9b43a3147a4159afc896b5b9046558f7f054e9cb" => :yosemite
    sha1 "7afabaeb2cc5624af27e47f32eb0f974bee73de1" => :mavericks
    sha1 "4d1f559599d47aed0b1be261c6bdd7e6e3ad04e8" => :mountain_lion
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "./build"
    bin.install "bin/fleetctl"
  end
end
