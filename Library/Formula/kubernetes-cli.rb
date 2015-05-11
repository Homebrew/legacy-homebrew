class KubernetesCli < Formula
  homepage "http://kubernetes.io/"
  url "https://github.com/GoogleCloudPlatform/kubernetes/archive/v0.16.2.tar.gz"
  sha256 "121b93fb97afec4facd22f6d835e630288bfe973029afd7ca689920ad67e719e"

  bottle do
    cellar :any
    sha256 "fe80d9e88b360bae975f01b28ae938520b7c3b2df00f29b7c68be75399f4d16b" => :yosemite
    sha256 "d6484d438cf3df8457c2a79fb9acc831306068a0ee8f9df15d5bd86dabe7432b" => :mavericks
    sha256 "e0f22bedc91e7c6b025c2ef470df4cb3f96d2fbcea6480d52a4c0d203266996f" => :mountain_lion
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
