class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "http://kubernetes.io/"
  head "https://github.com/kubernetes/kubernetes.git"

  stable do
    url "https://github.com/kubernetes/kubernetes/archive/v1.1.7.tar.gz"
    sha256 "0e86adc3e108f5beffe5e0be4b1758b381fc0308052402640250ba80267379f7"
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "ec58068f4ed51cfa6957a16d8849c9353e0ba5700d1a78d136949a739dd29a27" => :el_capitan
    sha256 "8625eb04bc5da762df0a3989e6ee6d2d7d4ad9d7c8f298cf2d49c21ba1deff65" => :yosemite
    sha256 "03365ff9aa75a36e55df33f0f69bbac9d1bafc69544a09bba7b3a2a06069b89b" => :mavericks
  end

  devel do
    url "https://github.com/kubernetes/kubernetes/archive/v1.2.0-alpha.4.tar.gz"
    sha256 "0c1d1a57ceb5beffcc7f8852d0d680ee37fc8e21814c74a0ea09e711e2c8aa44"
    version "1.2.0-alpha.4"
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
