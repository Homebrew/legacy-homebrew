require "formula"

class Docker < Formula
  homepage "http://docker.io"
  url "https://github.com/dotcloud/docker/archive/v0.8.0.tar.gz"
  sha1 "1e9362dab2ac2ecb4a1f193a7e72d060000438c3"

  depends_on 'go' => :build

  def install
    ENV["GOPATH"] = buildpath/'vendor'

    # Please remember to get the commit hash from release page
    # https://github.com/dotcloud/docker/releases/
    ENV['DOCKER_GITCOMMIT'] = "cc3a8c8d8ec57e15b7b7316797132d770408ab1a"

    # Must include Docker's own go libraries on the right path
    dotcloud = "vendor/src/github.com/dotcloud"
    (buildpath/dotcloud).mkpath
    ln_s "../../../../", dotcloud + "/docker"

    inreplace "hack/make/dynbinary", /sha1sum/, "shasum"

    system "hack/make.sh", "dynbinary"
    bin.install "bundles/0.8.0/dynbinary/docker-0.8.0" => "docker"

    (libexec/'docker').install "bundles/0.8.0/dynbinary/dockerinit-0.8.0" => "dockerinit"
  end

  test do
    system "#{bin}/docker", "--version"
  end
end
