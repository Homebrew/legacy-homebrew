require "formula"

class Boot2docker < Formula
  homepage "https://github.com/boot2docker/boot2docker"
  head "https://github.com/boot2docker/boot2docker.git"
  url 'https://github.com/boot2docker/boot2docker/archive/v0.9.1.tar.gz'
  sha1 '543cf1a2d1e29e0cbd34874da4ae966fcbc8d1de'

  depends_on "docker" => :recommended

  def install
    bin.install "boot2docker"
  end
end
