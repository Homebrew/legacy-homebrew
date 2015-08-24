class Gollum < Formula
  desc "A n:m message multiplexer written in Go"
  homepage "https://github.com/trivago/gollum"
  url "https://github.com/trivago/gollum/releases/download/v0.3.2/gollum_mac.zip"
  version "0.3.2"
  sha256 "3cd4017f423e84f111a952d3cb4fff468f433e24d458fec99de7e8acc66be5cc"

  def install
    bin.install("gollum")
  end

  test do
    system "true"
  end
end
