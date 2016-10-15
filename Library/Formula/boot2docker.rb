require 'formula'

class Boot2docker < Formula
  homepage 'https://github.com/steeve/boot2docker'
  url 'https://github.com/steeve/boot2docker/archive/v0.5.2.tar.gz'
  sha1 '487bf0556c97a35fd4af942e2802be0b34c3fd74'

  depends_on 'homebrew/binary/docker'

  def install
    bin.install 'boot2docker'
  end

  test do
    system "#{bin}/boot2docker", 'info'
  end

end
