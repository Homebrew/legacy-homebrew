class DockerMachine < Formula
  homepage "https://github.com/docker/machine"
  version "0.0.2"
  ## Version 0.0.2 doesn't build, so we install a downloaded binary
  ## unless this is a HEAD build.
  # url "https://github.com/docker/machine/archive/0.0.2.tar.gz"
  # sha1 "adcc7128abdbaae60ba3c58d6485df939c7e5510"
  url "https://github.com/docker/machine/releases/download/0.0.2/machine_darwin_amd64"
  sha1 "daecfe7e86a7c6a8dc444e03c5527f9db36b9c3e"
  head "https://github.com/docker/machine.git"

  depends_on "go" => :build
  depends_on "mercurial" => :build

  def install
    if build.head?
      ENV["GOPATH"] = buildpath
      system "go", "get", "-d", "-v"
      system "go", "build", "-o", name
    else
      mv "machine_darwin_amd64", name
    end
    bin.install name
  end

  test do
    system "#{bin}/#{name}", "--version"
  end
end
