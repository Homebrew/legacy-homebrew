require "formula"

class Docker < Formula
  homepage "http://docker.io"
  url "https://github.com/dotcloud/docker.git", :tag => "v0.9.0"

  option "without-completions", "Disable bash/zsh completions"

  bottle do
    sha1 "b05505850b41b6d2498d3f5f372762c621f70555" => :mavericks
    sha1 "ecdb854ee7903a042f684f6acd2cca1142b0a374" => :mountain_lion
    sha1 "b26ecae5bfb99bcec8aa532b2e721a0cec4f7427" => :lion
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
