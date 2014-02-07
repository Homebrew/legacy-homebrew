require "formula"

class Docker < Formula
  homepage "http://docker.io"
  url "https://github.com/dotcloud/docker.git", :tag => "v0.8.0"
  sha1 "1e9362dab2ac2ecb4a1f193a7e72d060000438c3"

  depends_on "go" => :build

  def install
    ENV["DOCKER_GITCOMMIT"] = downloader.cached_location.cd do
      `git rev-parse HEAD`
    end
    ENV["GOPATH"] = "#{buildpath}/vendor"
    (buildpath/"vendor/src/github.com/dotcloud").mkpath
    ln_s buildpath, "vendor/src/github.com/dotcloud/docker"
    inreplace "hack/make/dynbinary", "sha1sum", "shasum"

    system "hack/make.sh", "dynbinary"
    bin.install "bundles/0.8.0/dynbinary/docker-0.8.0" => "docker"
    bin.install "bundles/0.8.0/dynbinary/dockerinit-0.8.0" => "dockerinit"
  end

  test do
    system "#{bin}/docker", "--version"
  end
end
