class DockerMachine < Formula
  homepage "https://github.com/docker/machine"
  # Version 0.0.2 doesn't build, so we're head-only for now.
  # url "https://github.com/docker/machine/archive/0.0.2.tar.gz"
  # sha1 "adcc7128abdbaae60ba3c58d6485df939c7e5510"
  head "https://github.com/docker/machine.git"

  depends_on "go" => :build
  depends_on "mercurial" => :build
  depends_on "docker" => :recommended

  def install
    ENV["GOPATH"] = buildpath
    system "go", "get", "-d", "-v"
    system "go", "build", "-o", name
    bin.install name
  end

  test do
    system "#{bin}/#{name}", "--version"
  end
end
