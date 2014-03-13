require "formula"

class Boot2docker < Formula
  homepage "https://github.com/boot2docker/boot2docker"
  head "https://github.com/boot2docker/boot2docker.git"
  url 'https://github.com/boot2docker/boot2docker/archive/v0.7.0.tar.gz'
  sha1 'd61dc8cdd3b0fd8ce8f8443c4d621f0f87220b0f'

  depends_on "docker" => :recommended

  def install
    bin.install "boot2docker"
  end
end
