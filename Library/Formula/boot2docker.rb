require "formula"

class Boot2docker < Formula
  homepage "https://github.com/boot2docker/boot2docker"
  head "https://github.com/boot2docker/boot2docker.git"
  url 'https://github.com/boot2docker/boot2docker/archive/v0.6.0.tar.gz'
  sha1 'e90ed901375a345e23685aa8e0f9e3b83db11eff'

  depends_on "docker" => :recommended

  def install
    bin.install "boot2docker"
  end
end
