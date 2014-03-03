require "formula"

class Docker < Formula
  homepage "http://docker.io"
  url "https://github.com/dotcloud/docker.git", :tag => "v0.8.1"

  option "without-completions", "Disable bash/zsh completions"

  depends_on "go" => :build

  def install
    ENV["GIT_DIR"] = cached_download/".git"
    ENV["AUTO_GOPATH"] = "1"

    system "hack/make.sh", "dynbinary"
    bin.install "bundles/0.8.1/dynbinary/docker-0.8.1" => "docker"

    if build.with? "completions"
      bash_completion.install "contrib/completion/bash/docker"
      zsh_completion.install "contrib/completion/zsh/_docker"
    end
  end

  test do
    system "#{bin}/docker", "--version"
  end
end
