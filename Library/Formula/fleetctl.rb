require "formula"

class Fleetctl < Formula
  homepage "https://github.com/coreos/fleet"
  url "https://github.com/coreos/fleet/archive/v0.6.1.tar.gz"
  sha1 "2a839172b5801b98994d2fc69cfe691a612a3bce"
  head "https://github.com/coreos/fleet.git"

  bottle do
    sha1 "80417f9cb656b30100f5fb06bb4d4067a6cd3d93" => :mavericks
    sha1 "a8cb08ce6ed71d44bbede0eb50260e14851d6ae2" => :mountain_lion
    sha1 "a62e570c01a879c361b36a7b6b91db6fc052e9b2" => :lion
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "./build"
    bin.install "bin/fleetctl"
  end
end
