class KubernetesCli < Formula
  homepage "http://kubernetes.io/"
  url "https://github.com/GoogleCloudPlatform/kubernetes/archive/v0.11.0.tar.gz"
  sha256 "5eceee178649b12fbbae3a484457f067468db1811945502a36778c5e8807b2ff"

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
    bin.install "#{dir}/kubectl", "#{dir}/kubernetes"
  end

  test do
    assert_match /^kubectl controls the Kubernetes cluster manager./, shell_output("#{bin}/kubectl 2>&1", 0)
    assert_match %r{^Usage of #{bin}/kubernetes:}, shell_output("#{bin}/kubernetes --help 2>&1", 2)
  end
end
