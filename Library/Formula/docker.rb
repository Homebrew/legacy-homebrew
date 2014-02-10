require "formula"

class Docker < Formula
  homepage "http://docker.io"
  url "https://github.com/dotcloud/docker.git", :tag => "v0.8.0"
  sha1 "1e9362dab2ac2ecb4a1f193a7e72d060000438c3"

  bottle do
    revision 1
    sha1 "d2cdd9ed152a43cf1008a1025a9fefa5b9cb6ed3" => :mavericks
    sha1 "809bc0bbceb5d8d690f8ac6230ebe2d4ffc5aa9c" => :mountain_lion
    sha1 "cbef97454f2b063b0345d75c6642d09c9fdb2949" => :lion
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
