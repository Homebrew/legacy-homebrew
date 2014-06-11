require "formula"

class Srvdir < Formula
  homepage "https://www.srvdir.net/"
  url "https://dl.srvdir.net/darwin_amd64/srvdir.zip"
  sha1 "119407ed6abb5ee411a14ec64cfef469926d42e8"
  version "0.1"

  def install
    bin.install "srvdir"
  end

end
