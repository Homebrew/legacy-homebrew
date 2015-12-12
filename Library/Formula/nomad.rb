class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://releases.hashicorp.com/nomad/0.2.1/nomad_0.2.1_darwin_amd64.zip"
  sha256 "7f40f24c7c386bff4f97fad89c258ca7549d9629260d319a71a27fbb9e9ba31f"
  version "0.2.1"

  bottle :unneeded

  def install
    bin.install "nomad"
  end

  test do
    system "#{bin}/nomad", "version"
  end
end
