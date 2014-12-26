class DockerMachine < Formula
  homepage "https://github.com/docker/machine"
  version "0.0.2"
  url "https://github.com/docker/machine/releases/download/0.0.2/machine_darwin_amd64"
  sha1 "daecfe7e86a7c6a8dc444e03c5527f9db36b9c3e"

  def install
    system "mv machine_darwin_amd64 machine"
    system "chmod +x machine"
    bin.install "machine"
  end
end
