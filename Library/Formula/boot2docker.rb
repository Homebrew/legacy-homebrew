require "formula"

class Boot2docker < Formula
  homepage "https://github.com/boot2docker/boot2docker"
  head "https://github.com/boot2docker/boot2docker.git"
  url 'https://github.com/boot2docker/boot2docker/archive/v0.12.0.tar.gz'
  sha1 'b1aaf38a89797611f2cbbfaf22693e1847d6f6d9'

  depends_on "docker" => :recommended

  def install
    bin.install "boot2docker"
  end
end
