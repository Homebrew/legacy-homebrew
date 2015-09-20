class KubernetesCli < Formula
  desc "Command-line tool for kubernetes, a cluster manager for Docker"
  homepage "http://kubernetes.io/"
  head "https://github.com/kubernetes/kubernetes.git"

  stable do
    url "https://github.com/kubernetes/kubernetes/archive/v1.0.6.tar.gz"
    sha256 "cb6d03ddc920ef5eca13d12688419dff0b21daf3bf45ad731bfcae57f15ce8ea"

    patch do
      url "https://github.com/kubernetes/kubernetes/commit/defe0f82bf99ce2ec5179d92475c00ce9beaf318.patch"
      sha256 "80e0267461f778b51a21f5876152de5e74730b7ffb77c7604fe1b63b7983d3ba"
    end
  end

  bottle do
    cellar :any
    sha256 "d5b5ae622a2744a524f9888fe531bccf5c4b6f588ae1125d1c13ea99e4279659" => :yosemite
    sha256 "67147c72573f6cca613900cf2cbd0495aa496a93c0258527d5bc17682e0b565b" => :mavericks
    sha256 "7f627039b58de7689edf4bdd7a8ac24da309efa27e20ceea9a2add69b60b500c" => :mountain_lion
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
