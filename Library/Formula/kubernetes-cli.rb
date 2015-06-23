class KubernetesCli < Formula
  desc "Command-line tool for kubernetes, a cluster manager for Docker"
  homepage "http://kubernetes.io/"
  url "https://github.com/GoogleCloudPlatform/kubernetes/archive/v0.19.3.tar.gz"
  sha256 "1f7161939f3daef8ec8b2af7a2ed10bbdb88c08ce0afb76926c44de5edacc4d2"
  head "https://github.com/GoogleCloudPlatform/kubernetes.git"

  bottle do
    cellar :any
    sha256 "3991ff586e451b14972b3a5a16009c5177b4466e880487b1a73e6cfade9089a0" => :yosemite
    sha256 "489a6ffe40941aef053257ae9e36cffc65b823041a2fa1f47b28c7fccba3e06b" => :mavericks
    sha256 "97d7604bd9e7c510041cb2d471841247f8c66a890885f2d6741706221ded6fe8" => :mountain_lion
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
