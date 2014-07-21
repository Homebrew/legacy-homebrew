require "formula"

class Docker < Formula
  homepage "http://docker.io"
  url "https://github.com/dotcloud/docker.git", :tag => "v1.1.1"

  bottle do
    sha1 "b8d67a0d93bb0e2cdab603a422e9d0c97bea2424" => :mavericks
    sha1 "da44fe5a0fb2c4d625fbf994f6e7f5fc8b158016" => :mountain_lion
    sha1 "cdad8838bff3e97c113b883875bf4014e843662b" => :lion
  end

  option "without-completions", "Disable bash/zsh completions"

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
