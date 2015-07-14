class KubernetesCli < Formula
  desc "Command-line tool for kubernetes, a cluster manager for Docker"
  homepage "http://kubernetes.io/"
  url "https://github.com/GoogleCloudPlatform/kubernetes/archive/v1.0.0.tar.gz"
  sha256 "8aa74850d5549e9c659d1c2e821e26ae16596ca92d79406959a20f26b7526cf5"
  head "https://github.com/GoogleCloudPlatform/kubernetes.git"

  bottle do
    cellar :any
    sha256 "a2496ee1bb13c5414140390e002dc510a0266f9c44f86bcba42e55d91e5eee4c" => :yosemite
    sha256 "536577b748dd0d3f18d07827d2245eabd0ed371ad1e4715c84ba348ffc4c10d0" => :mavericks
    sha256 "06b6d8c50db75c1473dc739a6083d64a6ce92fee8d352e38e8414e64ce3f525a" => :mountain_lion
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
