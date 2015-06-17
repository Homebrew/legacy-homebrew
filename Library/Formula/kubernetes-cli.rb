class KubernetesCli < Formula
  desc "Command-line tool for kubernetes, a cluster manager for Docker"
  homepage "http://kubernetes.io/"
  url "https://github.com/GoogleCloudPlatform/kubernetes/archive/v0.17.1.tar.gz"
  sha256 "24d0109a3c9eb5fef394508c7effd6610f8e2e025a87060d76ddba73086b9050"

  bottle do
    cellar :any
    sha256 "f01000218846ad7a3247492c29dd0dbd1862486b4b5deefbbf5c4e2f8e06d0fc" => :yosemite
    sha256 "4c5f86844a6f0e863870b98d1512f5f5291bd4c3ac22ec458f2e5f47ed62878b" => :mavericks
    sha256 "7367b8334633201580674dbe8b2d44207ab07099a95e3fd9acb67845329a0540" => :mountain_lion
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
