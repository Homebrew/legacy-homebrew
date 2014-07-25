require "formula"

class LinuxHeaders < Formula
  homepage "http://kernel.org/"
  url "https://www.kernel.org/pub/linux/kernel/v3.x/linux-3.15.6.tar.xz"
  sha1 "d8928e10aed8cfc8b16859f0147c2470624372e6"

  def install
    system "make", "headers_install", "INSTALL_HDR_PATH=#{prefix}"
  end
end
