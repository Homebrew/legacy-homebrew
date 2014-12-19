require "formula"

class Docker < Formula
  homepage "https://www.docker.com/"
  # Boot2docker and docker are generally updated at the same time.
  # Please update the version of boot2docker too
  url "https://github.com/docker/docker.git", :tag => "v1.3.3"

  bottle do
    sha1 "aa72e6dd64d8b2f6f4f733e20cd2bdaa1bb923e3" => :yosemite
    sha1 "18c1660c6baa6b9b03c0acb33627c70f98856e6f" => :mavericks
    sha1 "3d40663273ceda30b0bfac70447742d2ea11fcd4" => :mountain_lion
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
