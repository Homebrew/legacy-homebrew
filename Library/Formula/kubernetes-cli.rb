class KubernetesCli < Formula
  homepage "http://kubernetes.io/"
  url "https://github.com/GoogleCloudPlatform/kubernetes/archive/v0.10.1.tar.gz"
  sha256 "76000917bae4d8002884f24d33aa3ed23938fd1e39e89c73b8dfdd2d9c06fe24"

  bottle do
    cellar :any
    sha1 "6b5d4dcefb0bf290c68e06f9a2dde7ea73c72a45" => :yosemite
    sha1 "787545924940ca943c38ccdc2263b7b4c1b92211" => :mavericks
    sha1 "3e4b16e204f335cde95a08e27cddac7def5e6f4c" => :mountain_lion
  end

  depends_on "go" => :build

  def install
    arch = MacOS.prefer_64_bit? ? "amd64" : "x86"

    system "make", "all", "WHAT=cmd/*", "GOFLAGS=-v"

    dir = "_output/local/bin/darwin/#{arch}"
    bin.install "#{dir}/kubecfg", "#{dir}/kubectl", "#{dir}/kubernetes"
  end

  test do
    assert_match /^Usage: kubecfg/, shell_output("#{bin}/kubecfg 2>&1", 1)
    assert_match /^kubectl controls the Kubernetes cluster manager./, shell_output("#{bin}/kubectl 2>&1", 0)
    assert_match %r{^Usage of #{bin}/kubernetes:}, shell_output("#{bin}/kubernetes --help 2>&1", 2)
  end
end
