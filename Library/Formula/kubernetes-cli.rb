class KubernetesCli < Formula
  desc "Command-line tool for kubernetes, a cluster manager for Docker"
  homepage "http://kubernetes.io/"
  head "https://github.com/kubernetes/kubernetes.git"

  stable do
    url "https://github.com/kubernetes/kubernetes/archive/v1.1.1.tar.gz"
    sha256 "9b293a37a4782b1906f3f6e0412a064e15a0d55113c6c20ee035edd06e5579fb"
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "b5826dc1866428c7c425e7f32e80fe3cb9673d115d5d65d8f5dc1c0986aa66ef" => :el_capitan
    sha256 "38c6cee6369dcf82f039864b86011eab42312391425ef29f6ebfcadc9a991680" => :yosemite
    sha256 "9818b4ec9ef23410d383ec6bccf035654776431af758eb2eec7022d1d33c7609" => :mavericks
  end

  devel do
    url "https://github.com/kubernetes/kubernetes/archive/v1.2.0-alpha.3.tar.gz"
    sha256 "57dae812e9ab46e4bca6fa42b563461b69580247cad142b47a33bf57da44e803"
    version "1.2.0-alpha.3"
  end

  depends_on "go" => :build

  def install
    arch = MacOS.prefer_64_bit? ? "amd64" : "x86"

    system "make", "all", "WHAT=cmd/kubectl", "GOFLAGS=-v"

    dir = "_output/local/bin/darwin/#{arch}"
    bin.install "#{dir}/kubectl"
  end

  test do
    assert_match /^kubectl controls the Kubernetes cluster manager./, shell_output("#{bin}/kubectl 2>&1", 0)
  end
end
