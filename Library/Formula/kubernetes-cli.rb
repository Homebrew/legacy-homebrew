class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "http://kubernetes.io/"
  head "https://github.com/kubernetes/kubernetes.git"

  stable do
    url "https://github.com/kubernetes/kubernetes/archive/v1.1.2.tar.gz"
    sha256 "ffbbf62d7fa324b6f4c3dcdb229e028204ec458f7f78fbf87856a72ab29ec942"
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "9c8d0f91dc6e9978d51e655ea177b8beb9af9fc6df3eaf804efef6f566f5b59c" => :el_capitan
    sha256 "253a47d08e635d4e2ff5b767afe807fdcc0427dedcc105f397893df8b433e76b" => :yosemite
    sha256 "ff8685eede53a1c4a5a6ec00ea16df39dca651202c888318845414cb745756de" => :mavericks
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
