class DockerMachine < Formula
  homepage "https://docs.docker.com/machine"
  url "https://github.com/docker/machine/archive/v0.2.0.tar.gz"
  sha256 "ba4df6728280732e70dcabc2aeb903babac0bbefb3f1c11e7f131e3aad0f2131"
  head "https://github.com/docker/machine.git"

  bottle do
    cellar :any
    sha256 "3c4f95abe4ea2f9fe3f74675fe4a615a7e0dacc5b19fd8736890ef8f7986ed76" => :yosemite
    sha256 "dccb6caa7f58f2bdc38c1c9d4b4e7cf6344caeb64228b5292ea00066bbffd74e" => :mavericks
    sha256 "ed22e427b1ecb3965eac5184951d807c4ec91e49eb17997bbc10b1987e0450c4" => :mountain_lion
  end

  depends_on "go" => :build

  def install
    mkdir_p buildpath/"src/github.com/docker"
    ln_s buildpath, buildpath/"src/github.com/docker/machine"

    system "go", "build", "-o", "docker-machine"

    bin.install "docker-machine"
  end

  test do
    output = shell_output(bin/"docker-machine --version")
    assert output.include? "machine version 0.2.0 (HEAD)"
  end
end
