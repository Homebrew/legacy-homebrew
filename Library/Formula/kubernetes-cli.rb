class KubernetesCli < Formula
  homepage "http://kubernetes.io/"
  url "https://github.com/GoogleCloudPlatform/kubernetes/archive/v0.10.1.tar.gz"
  sha256 "76000917bae4d8002884f24d33aa3ed23938fd1e39e89c73b8dfdd2d9c06fe24"

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
