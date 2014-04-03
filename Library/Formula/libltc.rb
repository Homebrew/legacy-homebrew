require "formula"

class Libltc < Formula
  homepage "http://x42.github.io/libltc/"
  url "https://github.com/x42/libltc/releases/download/v1.1.3/libltc-1.1.3.tar.gz"
  sha1 "7a5ed324c4a8f87ae1165d8484a153efce18f803"

  # This patch has been fixed in the master branch not released yet
  patch do
    url "https://github.com/x42/libltc/compare/v1.1.3...b98e5d4094fbbc637fc83fe25d8348e41c325cf8.diff"
    sha1 "af5b04d173070e59c870270cc7180a86e5f47f37"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
