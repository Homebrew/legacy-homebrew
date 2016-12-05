class Conf2kube < Formula
  desc "Create Kubernetes secrets from configuration files"
  homepage "https://github.com/kelseyhightower/conf2kube"
  url "https://github.com/kelseyhightower/conf2kube/archive/0.0.1.tar.gz"
  sha256 "4462ac150059653c83235cb9c57ebf019aa377ad673d46cc6dbbc73a726cb732"
  head "https://github.com/kelseyhightower/conf2kube.git"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", "-o", "#{bin}/conf2kube"
  end

  test do
    shell_output("#{bin}/conf2kube -h", 2)
  end
end
