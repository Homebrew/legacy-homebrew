class KubernetesCli < Formula
  homepage "http://kubernetes.io/"
  url "https://github.com/GoogleCloudPlatform/kubernetes/archive/v0.16.0.tar.gz"
  sha256 "31ca6062206fb469c9ed6629056987d04ca95e8881c6e31ddba2fba46de8ae74"

  bottle do
    cellar :any
    sha256 "ffeaedc2d543f364c9a159091ced2251ab443a1965b68cb017c4e06813473915" => :yosemite
    sha256 "ac81e1a60d096b64e7fa3f9fb447cfd6d591f3b0c563dd9241988212385c3c6b" => :mavericks
    sha256 "b443172e857c6840d80d3f0538e3204460777ce42f368873fb01ad9643ada4b4" => :mountain_lion
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
