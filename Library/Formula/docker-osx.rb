require "formula"

class DockerOsx < Formula
  homepage "https://github.com/noplay/docker-osx"
  url "https://github.com/noplay/docker-osx/archive/0.7.6.tar.gz"
  sha1 "86f082da0a328742cf15683d53860d322822c6a7"

  depends_on "docker"

  def install
    bin.install "docker-osx"
  end
end
