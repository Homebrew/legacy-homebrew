require "formula"

class Docker < Formula
  homepage "http://docker.io"
  url "https://github.com/dotcloud/docker.git", :tag => "v0.8.0"
  sha1 "1e9362dab2ac2ecb4a1f193a7e72d060000438c3"

  bottle do
    sha1 "3ff7bceb60e918424e57a07d780d62a61443ae17" => :mavericks
    sha1 "f27703485378e335e4bde8fa0321087aa94a52a3" => :mountain_lion
    sha1 "3f054cc6e3f55cf3a14e466d19dde0adc2889dcf" => :lion
  end

  def patches
    "https://github.com/dotcloud/docker/commit/6174ba.patch"
  end

  depends_on "go" => :build

  def install
    ENV["DOCKER_GITCOMMIT"] = downloader.cached_location.cd do
      `git rev-parse HEAD`
    end
    ENV["AUTO_GOPATH"] = "1"
    inreplace "hack/make/dynbinary", "sha1sum", "shasum"

    system "hack/make.sh", "dynbinary"
    bin.install "bundles/0.8.0/dynbinary/docker-0.8.0" => "docker"
  end

  test do
    system "#{bin}/docker", "--version"
  end
end
