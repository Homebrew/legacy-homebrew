require "formula"

class Docker < Formula
  homepage "http://docker.io"
  url "https://github.com/dotcloud/docker.git", :tag => "v0.9.1"

  option "without-completions", "Disable bash/zsh completions"

  bottle do
    sha1 "eafc56bfc492a625714d8ce48b554b6d07579e06" => :mavericks
    sha1 "3151d6a5d9cf556335cb29584f9e6249b9975742" => :mountain_lion
    sha1 "898802f9b8c436e6f312efe93eefe4e7bf594562" => :lion
  end

  depends_on "go" => :build

  def install
    ENV["GIT_DIR"] = cached_download/".git"
    ENV["AUTO_GOPATH"] = "1"
    ENV["DOCKER_CLIENTONLY"] = "1"

    system "hack/make.sh", "dynbinary"
    bin.install "bundles/#{version}/dynbinary/docker-#{version}" => "docker"

    if build.with? "completions"
      bash_completion.install "contrib/completion/bash/docker"
      zsh_completion.install "contrib/completion/zsh/_docker"
    end
  end

  test do
    system "#{bin}/docker", "--version"
  end
end
