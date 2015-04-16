class KubernetesCli < Formula
  homepage "http://kubernetes.io/"
  url "https://github.com/GoogleCloudPlatform/kubernetes/archive/v0.14.1.tar.gz"
  sha256 "6262c5b56658bee3b025f2ddf3dbbd83b2cec7c126efc119d4a093e9c7428a2d"

  bottle do
    cellar :any
    sha256 "df553a4e397fae016030534f230295443e585570c174024adca59ad968369fab" => :yosemite
    sha256 "1aedd4db8efa8a5119e7a50d33dd40513179d695672bed3311555b9289256b9e" => :mavericks
    sha256 "51479589cec2d390bb8303af83c23e5189b9956a7c29df0bdff811e057891c8a" => :mountain_lion
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
