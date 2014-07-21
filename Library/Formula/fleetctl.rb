require "formula"

class Fleetctl < Formula
  homepage "https://github.com/coreos/fleet"
  url "https://github.com/coreos/fleet/archive/v0.5.4.tar.gz"
  sha1 "1fec5e4d23627446bce52eae691cb233ef03e17b"
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
