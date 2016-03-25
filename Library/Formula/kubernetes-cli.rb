class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "http://kubernetes.io/"
  head "https://github.com/kubernetes/kubernetes.git"

  stable do
    url "https://github.com/kubernetes/kubernetes/archive/v1.2.0.tar.gz"
    sha256 "8e7bc4761745549492fc9eab0dc730aadffa07004e234e96643e2907fef41476"
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "107a2b0702fb36f2f52520ce333b9d1187003f4c9d6ef45b8e43f4d713025ef9" => :el_capitan
    sha256 "ae002598f3b6887874402b2d791990fd99a1236539e5ce9aeee2b370e5fbe3d8" => :yosemite
    sha256 "d6032feca6988d3a1409c34763c545caba341503dcd093888b0a5b47c42c22c6" => :mavericks
  end

  devel do
    url "https://github.com/kubernetes/kubernetes/archive/v1.2.1-beta.0.tar.gz"
    sha256 "d85d88326a3bcfe9b445355cbea3421866726b09280b9fa78fd7146cff9e3e71"
    version "1.2.1-beta.0"
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
