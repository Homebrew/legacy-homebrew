class KubernetesCli < Formula
  desc "Command-line tool for kubernetes, a cluster manager for Docker"
  homepage "http://kubernetes.io/"
  head "https://github.com/kubernetes/kubernetes.git"

  stable do
    url "https://github.com/kubernetes/kubernetes/archive/v1.1.1.tar.gz"
    sha256 "9b293a37a4782b1906f3f6e0412a064e15a0d55113c6c20ee035edd06e5579fb"
  end

  devel do
    url "https://github.com/kubernetes/kubernetes/archive/v1.2.0-alpha.3.tar.gz"
    sha256 "57dae812e9ab46e4bca6fa42b563461b69580247cad142b47a33bf57da44e803"
    version "1.2.0-alpha.3"
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "a59a5ab167d925b35528520ab1a60c415d94db60eed99d21fe81dc241e6a82fd" => :el_capitan
    sha256 "ac55e7c91b57fc4deca92882ea7f32cb0486ac834734f45db71e53b57917242e" => :yosemite
    sha256 "29ae88758efbdbfd6c0a181c65cdd5ae19725dbfb9383f4b59ec9b8859c9e7e6" => :mavericks
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
