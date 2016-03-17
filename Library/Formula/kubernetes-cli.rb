class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "http://kubernetes.io/"
  head "https://github.com/kubernetes/kubernetes.git"

  stable do
    url "https://github.com/kubernetes/kubernetes/archive/v1.1.8.tar.gz"
    sha256 "fbc1a01edc6683dc3c59830a63622730c5baece1e02dfa1cd32a852bf4415581"
  end

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "3d55385a010d6cb3dbe8de1335d3fcb92d19f348478ff9e8050eea17f1df0b29" => :el_capitan
    sha256 "2ba21000c6252026fccbf1a4ff875577c834800e038741bbeafb3bd75c4cfce9" => :yosemite
    sha256 "13213f9b7230977fc931960ef025cc9ff40e93886d0958b41c2e0f152482d486" => :mavericks
  end

  devel do
    url "https://github.com/kubernetes/kubernetes/archive/v1.2.0.tar.gz"
    sha256 "8e7bc4761745549492fc9eab0dc730aadffa07004e234e96643e2907fef41476"
    version "1.2.0"
  end

  depends_on "go" => :build

  def install
    arch = MacOS.prefer_64_bit? ? "amd64" : "x86"

    system "make", "all", "WHAT=cmd/kubectl", "GOFLAGS=-v"

    dir = "_output/local/bin/darwin/#{arch}"
    bin.install "#{dir}/kubectl"
    bash_completion.install "contrib/completions/bash/kubectl"
  end

  test do
    assert_match /^kubectl controls the Kubernetes cluster manager./, shell_output("#{bin}/kubectl 2>&1", 0)
  end
end
