require "formula"

class Docker < Formula
  homepage "http://docker.io"
  # Boot2docker and docker are generally updated at the same time.
  # Please update the version of boot2docker too
  url "https://github.com/docker/docker.git", :tag => "v1.2.0"

  bottle do
    sha1 "92d2cb761ea3da18edfea52de6cb4ee113dba0aa" => :mavericks
    sha1 "eccd8540a0c57eca11456b3f060e67c430907c05" => :mountain_lion
    sha1 "6421cb3f6e5fd485e61731e004b2390629291867" => :lion
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
