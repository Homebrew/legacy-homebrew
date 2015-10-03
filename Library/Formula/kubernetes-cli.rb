class KubernetesCli < Formula
  desc "Command-line tool for kubernetes, a cluster manager for Docker"
  homepage "http://kubernetes.io/"
  head "https://github.com/kubernetes/kubernetes.git"

  stable do
    url "https://github.com/kubernetes/kubernetes/archive/v1.0.6.tar.gz"
    sha256 "cb6d03ddc920ef5eca13d12688419dff0b21daf3bf45ad731bfcae57f15ce8ea"

    patch do
      url "https://github.com/kubernetes/kubernetes/commit/defe0f82bf99ce2ec5179d92475c00ce9beaf318.patch"
      sha256 "80e0267461f778b51a21f5876152de5e74730b7ffb77c7604fe1b63b7983d3ba"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "91799da5fb9586873854f01476f1c4f38802c8eed113eb8019e2a920fd8f12cb" => :el_capitan
    sha256 "ce5e54feefc1130146a4dc603dad37cfd6951ecc5509c008d7afd1965757ceb7" => :yosemite
    sha256 "2914487bb8a3230dfcd6b155db1012bb2f1b214c10227cffd7db008318938613" => :mavericks
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
