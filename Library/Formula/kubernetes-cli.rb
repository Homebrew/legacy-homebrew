class KubernetesCli < Formula
  desc "Command-line tool for kubernetes, a cluster manager for Docker"
  homepage "http://kubernetes.io/"
  url "https://github.com/GoogleCloudPlatform/kubernetes/archive/v1.0.1.tar.gz"
  sha256 "a2f6a3ebd7ecda2b93ebd4fb2f2fb9e6c41153e40de29306c78fdd1316490247"
  head "https://github.com/GoogleCloudPlatform/kubernetes.git"

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
