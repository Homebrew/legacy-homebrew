class Wbox < Formula
  desc "HTTP testing tool and configuration-less HTTP server"
  homepage "http://hping.org/wbox/"
  url "http://www.hping.org/wbox/wbox-5.tar.gz"
  sha256 "1589d85e83c8ee78383a491d89e768ab9aab9f433c5f5e035cfb5eed17efaa19"

  def install
    system "make"
    bin.install "wbox"
  end

  test do
    system "#{bin}/wbox", "www.google.com", "1"
  end
end
