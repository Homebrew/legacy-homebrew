require "formula"

class LinuxHeaders < Formula
  homepage "http://kernel.org/"
  url "https://www.kernel.org/pub/linux/kernel/v3.x/linux-3.15.9.tar.xz"
  sha1 "c1bed517c0c7ff3514833ec99e1124ab20d9dc1d"

  def install
    system "make", "headers_install", "INSTALL_HDR_PATH=#{prefix}"
  end
end
