class RockerCompose < Formula
  desc "Docker tool for deploying apps composed of multiple containers."
  homepage "https://github.com/grammarly/rocker-compose"
  url "https://github.com/grammarly/rocker-compose/releases/download/0.1.0/rocker-compose-0.1.0_darwin_amd64.tar.gz"
  version "0.1.0"
  sha256 "9106fd69de0a2deaa71af220b0355e6d562ce3069a57c29a0b661eba9fb5e992"

  def install
    bin.install "rocker-compose"
  end

  test do
    system "#{bin}/rocker-compose", "--version"
  end
end
