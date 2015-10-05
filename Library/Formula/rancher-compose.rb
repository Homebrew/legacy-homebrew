class RancherCompose < Formula
  desc "Docker compose compatible client to deploy to Rancher"
  homepage "https://github.com/rancher/rancher-compose"
  url "https://github.com/rancher/rancher-compose/archive/v0.4.0.tar.gz"
  sha256 "07192c7ef554fadc1ef62c32ee942526f013109dd5bacb04642b22fd6f1aeec7"

  bottle do
    cellar :any_skip_relocation
    sha256 "a45c2c9e625c356affcf630d0791ff592b4e238d5591f84e925f8ad632d18dac" => :el_capitan
    sha256 "710902ca67278b5ffe06e9f2c6d1cb82d2e55ecc82983279a9f5538eb6cf41eb" => :yosemite
    sha256 "a6f4bda5d1ba7e98199238ebc1f7f1de4111a583fe5a5a30211cbe1d51ecc564" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = "#{buildpath}:#{buildpath}/Godeps/_workspace"
    mkdir_p "#{buildpath}/src/github.com/rancher"
    ln_s buildpath, "#{buildpath}/src/github.com/rancher/rancher-compose"
    system "go", "build", "-ldflags", "-w -X github.com/rancher/rancher-compose/version.VERSION #{version}", "-o", "#{bin}/rancher-compose"
  end

  test do
    system "#{bin}/rancher-compose", "help"
  end
end
