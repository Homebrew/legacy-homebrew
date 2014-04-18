require "formula"

class Boot2docker < Formula
  homepage "https://github.com/boot2docker/boot2docker"
  head "https://github.com/boot2docker/boot2docker.git"
  url 'https://github.com/boot2docker/boot2docker/archive/v0.8.0.tar.gz'
  sha1 'c6f07db7d3a4952f1508b92f8b32e02e2f316f85'

  depends_on "docker" => :recommended

  def install
    bin.install "boot2docker"
  end
end
