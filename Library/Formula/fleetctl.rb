require "formula"

class Fleetctl < Formula
  homepage "https://github.com/coreos/fleet"
  url "https://github.com/coreos/fleet/archive/v0.5.4.tar.gz"
  sha1 "1fec5e4d23627446bce52eae691cb233ef03e17b"
  head "https://github.com/coreos/fleet.git"

  bottle do
    sha1 "8abefa5ff7b326a0e607857ed9138ea67105f66f" => :mavericks
    sha1 "07d9277b0fabe907e138a444a237174cf9c44940" => :mountain_lion
    sha1 "8046e086e35a8beb49fab62deb4841687623cc04" => :lion
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "./build"
    bin.install "bin/fleetctl"
  end
end
