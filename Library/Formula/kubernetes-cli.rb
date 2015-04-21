class KubernetesCli < Formula
  homepage "http://kubernetes.io/"
  url "https://github.com/GoogleCloudPlatform/kubernetes/archive/v0.15.0.tar.gz"
  sha256 "839906d302e7b5ea0fa5e4524f0773326b0e395452e0ff3801fe61e278cb7e42"

  bottle do
    cellar :any
    sha256 "5891a7105ce68919bc0a4e3688c9d85c0fca9290b4522572ec2c59cfc0edd0cf" => :yosemite
    sha256 "383e7436941fc6909fb52caddfd6190e1b5678d50f47ce94b0f68ecc820abd75" => :mavericks
    sha256 "f5d7d8bb2edf6fe471f702ae8f1157df72fbd43df5cb357f5eabea92693629f4" => :mountain_lion
  end

  depends_on "go" => :build

  def install
    arch = MacOS.prefer_64_bit? ? "amd64" : "x86"

    system "make", "all", "WHAT=cmd/*", "GOFLAGS=-v"

    dir = "_output/local/bin/darwin/#{arch}"
    bin.install "#{dir}/kubectl", "#{dir}/kubernetes"
  end

  test do
    assert_match /^kubectl controls the Kubernetes cluster manager./, shell_output("#{bin}/kubectl 2>&1", 0)
    assert_match %r{^Usage of #{bin}/kubernetes:}, shell_output("#{bin}/kubernetes --help 2>&1", 2)
  end
end
