require "formula"

class Docker < Formula
  homepage "http://docker.io"
  # Boot2docker and docker are generally updated at the same time.
  # Please update the version of boot2docker too
  url "https://github.com/dotcloud/docker.git", :tag => "v1.1.2"

  bottle do
    sha1 "caaca765d2caf1c59904cbddfa8e62c89f32767d" => :mavericks
    sha1 "76443abf1eaaf9b3faea23157d17463b712b7b3f" => :mountain_lion
    sha1 "1b5e3c57a460be422a7fd36cb0105fe06b9d109b" => :lion
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
