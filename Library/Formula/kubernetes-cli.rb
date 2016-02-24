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
    sha256 "0ebbae000a1f339588e052d1aba970b8d04fc4050aa2362bc865198acf535de5" => :el_capitan
    sha256 "47bc25716067a1804506be5d670c148dc75c750cadad0475af0ee9048c6ee3b7" => :yosemite
    sha256 "afb9bb03e2df5018d92ee7a09c2f3e7d080736094dd1150d1b5f4f587f805ab1" => :mavericks
  end

  devel do
    url "https://github.com/kubernetes/kubernetes/archive/v1.2.0-alpha.8.tar.gz"
    sha256 "3ae607179a4b9adc7ed34f3877645e6e4cf9dad9bd17206bafb95019d38f60dc"
    version "1.2.0-alpha.8"
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
