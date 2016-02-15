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
    sha256 "bcb980c13a51892e6bbb790d457904ec9848df2bb0c4b6e327c84e6ae5fbf1c6" => :el_capitan
    sha256 "c96c7260c1d4f8c68fcaad15a94ef00f0716d3031502cdaf38f053e149b69182" => :yosemite
    sha256 "c54728bde0a501446191ee647d54b80e1a25f60b2050aa69e959e57c9a7f8104" => :mavericks
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
