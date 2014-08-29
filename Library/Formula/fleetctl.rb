require "formula"

class Fleetctl < Formula
  homepage "https://github.com/coreos/fleet"
  url "https://github.com/coreos/fleet/archive/v0.7.1.tar.gz"
  sha1 "78b072d91845c75613a48c8424c27f1422cceb51"
  head "https://github.com/coreos/fleet.git"

  bottle do
    sha1 "7fe9d8004545528239bdaa189886ce8dde620368" => :mavericks
    sha1 "17e53f7304ca738b12a1a76112c1063793a8fb99" => :mountain_lion
    sha1 "a2c9e731cfb9b4ac3e4b9fa03e0533821a60695f" => :lion
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "./build"
    bin.install "bin/fleetctl"
  end
end
