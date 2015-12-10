class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "http://kubernetes.io/"
  head "https://github.com/kubernetes/kubernetes.git"

  stable do
    url "https://github.com/kubernetes/kubernetes/archive/v1.1.3.tar.gz"
    sha256 "b844e82fad688f62ed29ede1c61677d45d1a4c4c52ac08958e3ad1e650c10756"
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "9c8d0f91dc6e9978d51e655ea177b8beb9af9fc6df3eaf804efef6f566f5b59c" => :el_capitan
    sha256 "253a47d08e635d4e2ff5b767afe807fdcc0427dedcc105f397893df8b433e76b" => :yosemite
    sha256 "ff8685eede53a1c4a5a6ec00ea16df39dca651202c888318845414cb745756de" => :mavericks
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
  end

  test do
    assert_match /^kubectl controls the Kubernetes cluster manager./, shell_output("#{bin}/kubectl 2>&1", 0)
  end
end
