require "formula"

class Boot2docker < Formula
  homepage "https://github.com/boot2docker/boot2docker"
  head "https://github.com/boot2docker/boot2docker.git"
  url 'https://github.com/boot2docker/boot2docker/archive/v0.7.1.tar.gz'
  sha1 '447ab4bd75d31654f93e546bab20a9ba6e1a4dcd'

  depends_on "docker" => :recommended

  def install
    bin.install "boot2docker"
  end
end
