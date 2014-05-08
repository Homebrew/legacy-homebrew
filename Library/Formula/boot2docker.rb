require "formula"

class Boot2docker < Formula
  homepage "https://github.com/boot2docker/boot2docker"
  head "https://github.com/boot2docker/boot2docker.git"
  url 'https://github.com/boot2docker/boot2docker/archive/v0.8.1.tar.gz'
  sha1 'f52d77544ab4ba1462a8f9c0c2b2d214cffb1059'

  depends_on "docker" => :recommended

  def install
    bin.install "boot2docker"
  end
end
