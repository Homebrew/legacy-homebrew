require "language/go"

class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.docker.com/machine"
  url "https://github.com/docker/machine/archive/v0.5.1.tar.gz"
  sha256 "cd515d9b2d14edb9ce3429865cb9cdadc81d7c4ba685422fbd1ee10025987460"
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
