class KubernetesCli < Formula
  homepage "http://kubernetes.io/"
  url "https://github.com/GoogleCloudPlatform/kubernetes/archive/v0.17.0.tar.gz"
  sha256 "fc138505b3dca03585b42a91e48f56d87d17f22affe6947c6b501c2098f8d301"

  bottle do
    cellar :any
    sha256 "78c8fb63ae5d9f889a301b9178583d617d074c1e6732e4ff25e9a438df273e5f" => :yosemite
    sha256 "7c58197b78ed716985b2beeb2727a53891ada287537971eba3c7317d52160e09" => :mavericks
    sha256 "ced9e46affcc309ead764a23a711a27cb5b610cf28a2139eca716d16e3e89ad8" => :mountain_lion
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
