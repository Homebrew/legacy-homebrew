require "formula"

class Boot2docker < Formula
  homepage "https://github.com/steeve/boot2docker"
  url 'https://github.com/steeve/boot2docker/archive/v0.5.4.tar.gz'
  sha1 '881630491b335230d62a679b8dfbb52c3e249fb8'

  depends_on "docker"

  def install
    bin.install "boot2docker"
  end

  test do
    system "#{bin}/boot2docker", "info"
  end
end
