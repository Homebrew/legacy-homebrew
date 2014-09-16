require "formula"

class Sshrc < Formula
  homepage "https://github.com/Russell91/sshrc"
  url "https://github.com/Russell91/sshrc/archive/0.4.tar.gz"
  sha1 "9e9426323d6b2cb118275b2d5836510dbd87a75a"

  def install
    bin.install "sshrc"
  end
end
