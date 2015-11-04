class KubernetesCli < Formula
  desc "Command-line tool for kubernetes, a cluster manager for Docker"
  homepage "http://kubernetes.io/"
  head "https://github.com/kubernetes/kubernetes.git"

  stable do
    url "https://github.com/kubernetes/kubernetes/archive/v1.0.7.tar.gz"
    sha256 "4136d0ddbde0de77cbdee265ce1f73e22eff1ec31dde62a5093f9944230eb861"
  end

  devel do
    url "https://github.com/kubernetes/kubernetes/archive/v1.1.1-beta.1.tar.gz"
    sha256 "014cc51218bffba0d58be208e206fcdf2bcf391dd418d572d476f44a89f5ef5f"
    version "1.1.1-beta.1"
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

    system "make", "all", "WHAT=cmd/kubectl", "GOFLAGS=-v"

    dir = "_output/local/bin/darwin/#{arch}"
    bin.install "#{dir}/kubectl"
  end

  test do
    assert_match /^kubectl controls the Kubernetes cluster manager./, shell_output("#{bin}/kubectl 2>&1", 0)
  end
end
