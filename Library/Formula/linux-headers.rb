require "formula"

class LinuxHeaders < Formula
  homepage "http://kernel.org/"
  url "https://www.kernel.org/pub/linux/kernel/v3.x/linux-3.15.9.tar.gz"
  sha1 "068aefd8d7a5ef62e152d6d45228c53bdec4a2cc"

  def install
    system "make", "headers_install", "INSTALL_HDR_PATH=#{prefix}"
  end
end
