require "language/go"

class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.docker.com/machine"
  url "https://github.com/docker/machine/archive/v0.5.2.tar.gz"
  sha256 "2dd6ed03e546a7c733ec6964b47b85b6d328e830ebca318240f6ddfcaed6f98a"
  head "https://github.com/docker/machine.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "49079c3480844940857b15c7cc67a51375b3dd11b3f4cb6e5011ebec325db209" => :el_capitan
    sha256 "6b29398cde25169d09a10724da58750109a659f5c539f3a61df01073c48aaec6" => :yosemite
    sha256 "12631a5d4ed753a71f9db2860d38d938f45aa168c8ffb895b06c1fcf752ad49c" => :mavericks
  end

  depends_on "go" => :build
  depends_on "automake" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/docker/"
    ln_sf buildpath, buildpath/"src/github.com/docker/machine"

    system "make", "build"
    bin.install Dir["bin/*"]

    bash_completion.install Dir["contrib/completion/bash/*.bash"]
  end

  test do
    system bin/"docker-machine", "ls"
  end
end
