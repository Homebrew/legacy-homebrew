class KubernetesCli < Formula
  homepage "http://kubernetes.io/"
  url "https://github.com/GoogleCloudPlatform/kubernetes/archive/v0.12.1.tar.gz"
  sha256 "a119cfafe512fa6847dcd3ef728e5c7cd1a09cd83f2af8720d81d9e76c05d8c2"

  bottle do
    cellar :any
    sha256 "e0b40e4598e485401426946827281a9075f01dbe8c4e93c5255c4b5924065010" => :yosemite
    sha256 "cde29df3cdade3a465eaf83a35517962d8d396312354fe7c0b1ae69fc5dacaf8" => :mavericks
    sha256 "941e8af8848cda083e58056b71319a11727577a20bd887740e19fa3c9984abba" => :mountain_lion
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
