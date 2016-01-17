require "language/go"

class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.docker.com/machine"
  url "https://github.com/docker/machine.git",
    :tag => "v0.5.6",
    :revision => "61388e98540321b34f4a27f88df9e7a4443b9ac8"
  revision 1

  head "https://github.com/docker/machine.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "375dab55757b24a748c8fed3c6ccfc8fc5bc8a3e11b760d4b4bca23a48059342" => :el_capitan
    sha256 "769f5e530c02952ccc39f21d3a192b828268d1bc3f324e919a621d1997ccc2e8" => :yosemite
    sha256 "3980502fec793ca87b6704820dd19aa9a0169f5672f971855d9da067501ac4ee" => :mavericks
  end

  depends_on "go" => :build
  depends_on "automake" => :build

  def install
    ENV["GOBIN"] = bin
    ENV["GOPATH"] = buildpath
    ENV["GOHOME"] = buildpath

    path = buildpath/"src/github.com/docker/machine"
    path.install Dir["*"]

    Language::Go.stage_deps resources, buildpath/"src"

    cd path do
      system "make", "build"
      bin.install Dir["bin/*"]
      bash_completion.install Dir["contrib/completion/bash/*.bash"]
    end
  end

  test do
    system bin/"docker-machine", "ls"
  end
end
