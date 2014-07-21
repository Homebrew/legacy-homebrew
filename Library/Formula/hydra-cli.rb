require "formula"

class HydraCli < Formula
  homepage 'https://github.com/sdegutis/hydra-cli'
  url 'https://github.com/sdegutis/hydra-cli/archive/1.0.tar.gz'
  sha1 '15906ca4255839844635f26eab83843f0426b5f9'
  head 'https://github.com/sdegutis/hydra-cli.git'

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/hydra", "-h"
  end
end
