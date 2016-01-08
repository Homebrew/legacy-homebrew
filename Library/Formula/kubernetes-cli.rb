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
    sha256 "d44cdd07b83b85cc258230a0d8e112c051cd22bbcde9078537282e0acb044864" => :el_capitan
    sha256 "bc307191e88c0a53b561995830f605ecbe30edff04aa8708abb68de0046154b0" => :yosemite
    sha256 "d31979735c45bdce569a7cbaacc3fa81531d5f0280ef666bf437a7e795f56ba6" => :mavericks
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
