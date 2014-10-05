require "formula"

class Iproute2mac < Formula
  homepage "https://github.com/brona/iproute2mac"
  url "https://github.com/brona/iproute2mac/archive/v1.0.0.tar.gz"
  sha1 "4b33511acdd35845ecdadad31b932aab0ab7cd81"

  def install
    mv "src/ip.py", "src/ip"
    bin.install "src/ip"
  end
end
