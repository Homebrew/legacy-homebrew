class DockerMachineParallels < Formula
  desc "Docker Machine Parallels Driver"
  homepage "https://github.com/Parallels/docker-machine-parallels"
  url "https://github.com/Parallels/docker-machine-parallels/archive/v1.1.1.tar.gz"
  sha256 "a085bbc8c231f4629d3404677f73b49bff2414f7002f0e9acf9aee8cdae15829"
  revision 2

  head "https://github.com/Parallels/docker-machine-parallels.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "97ab0dd6dd002db4030eafc503cc16bad101c8846bc4cb8465547344bab2e126" => :el_capitan
    sha256 "9b9956518d9ee26b1df6a4fc98fce1312969f9934ed76294f04f0fe960917cc8" => :yosemite
    sha256 "99f8bed56791ea2227500ad1a1a5abc9cfd0de25e705b7bf99ceaa4ccf877478" => :mavericks
  end

  depends_on "go" => :build
  depends_on "docker-machine"

  def install
    ENV["GOPATH"] = buildpath

    path = buildpath/"src/github.com/Parallels/docker-machine-parallels"
    path.install Dir["*"]

    cd path do
      system "make", "build"
      bin.install "bin/docker-machine-driver-parallels"
    end

    prefix.install_metafiles path
  end

  test do
    assert_match "parallels-memory", shell_output("docker-machine create -d parallels -h")
  end
end
