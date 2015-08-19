class Redsocks < Formula
  desc "Transparent socks redirector"
  homepage "http://darkk.net.ru/redsocks"
  url "https://github.com/darkk/redsocks/archive/release-0.4.tar.gz"
  sha256 "618cf9e8cd98082db31f4fde6450eace656fba8cd6b87aa4565512640d341045"

  depends_on "libevent"

  def install
    system "make"
    bin.install "redsocks"
  end
end
