require "formula"

class Dev < Formula
  homepage "https://github.com/Xe/dev"
  url "https://github.com/Xe/dev/releases/download/0.3/dev-0.3.tgz"
  sha1 "dc25508f6cfb0ad43db7faa46c1c097ae925205a"

  def install
    system "cp dev-osx-amd64 dev"
    bin.install "dev"
  end

  test do
    system "dev"
  end
end
