require "formula"

class Boot2docker < Formula
  homepage "https://github.com/boot2docker/boot2docker"
  head "https://github.com/boot2docker/boot2docker.git"
  url 'https://github.com/boot2docker/boot2docker/archive/v1.0.0.tar.gz'
  sha1 'e4bd3db2cfa82aedcaedebc0564c3cc4fa50f9d3'

  depends_on "docker" => :recommended

  def install
    bin.install "boot2docker"
  end
end
