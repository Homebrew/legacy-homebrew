require "formula"

class LinuxHeaders < Formula
  homepage "http://kernel.org/"
  url "https://www.kernel.org/pub/linux/kernel/v3.x/linux-3.15.9.tar.gz"
  sha1 "068aefd8d7a5ef62e152d6d45228c53bdec4a2cc"

  bottle do
    cellar :any
    sha1 "69c321f2cfca43e39891d34b6b088b4b786007e6" => :x86_64_linux
  end

  def install
    system "make", "headers_install", "INSTALL_HDR_PATH=#{prefix}"
    rm Dir[prefix/"**/{.install,..install.cmd}"]
  end
end
