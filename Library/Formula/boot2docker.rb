require "formula"

class Boot2docker < Formula
  homepage "https://github.com/boot2docker/boot2docker"
  head "https://github.com/boot2docker/boot2docker.git"
  url 'https://github.com/boot2docker/boot2docker/archive/v0.9.0.tar.gz'
  sha1 '8be6007108eaca3c605e67997747063ba147a547'

  depends_on "docker" => :recommended

  def install
    bin.install "boot2docker"
  end
end
