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
