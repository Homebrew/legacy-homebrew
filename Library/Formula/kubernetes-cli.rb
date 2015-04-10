class KubernetesCli < Formula
  homepage "http://kubernetes.io/"
  url "https://github.com/GoogleCloudPlatform/kubernetes/archive/v0.14.1.tar.gz"
  sha256 "6262c5b56658bee3b025f2ddf3dbbd83b2cec7c126efc119d4a093e9c7428a2d"

  bottle do
    cellar :any
    sha256 "22c5bdbab35eac651b318e1b2782cf187cbd9c3a3ec48cc335d24a06df68a102" => :yosemite
    sha256 "f3230e4eb5ad6cc257a0092a9d0a9d0babb7fea2bb0b564ccabeefd2b7e57b63" => :mavericks
    sha256 "aaed6fb92a011deeff7c1bf413dd4bb376e9c482f964fa0450653440c93ba8c1" => :mountain_lion
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
