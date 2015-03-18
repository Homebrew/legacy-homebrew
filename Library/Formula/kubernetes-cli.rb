class KubernetesCli < Formula
  homepage "http://kubernetes.io/"
  url "https://github.com/GoogleCloudPlatform/kubernetes/archive/v0.13.1.tar.gz"
  sha256 "d65a0ded976331bec79cf0b0756b063136dd23984edd16db187344f61629dc99"

  bottle do
    cellar :any
    sha256 "683dba9d5351bb634382b9e97d0525cb472dedf29e932f3308c635e59421f303" => :yosemite
    sha256 "e29327d2e21215d13bd88f678f1f54177a4c696b18b33116158c9ed1af79e992" => :mavericks
    sha256 "5a2994dad8ab72b0e23b51d6ad4845c1eda439b2fe84a4077a9e23e82b686ff6" => :mountain_lion
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
