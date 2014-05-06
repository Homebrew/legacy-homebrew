require "formula"

class Reop < Formula
  homepage "http://www.tedunangst.com/flak/post/reop"
  head 'https://github.com/tedu/reop.git', :using => :git

  depends_on "libsodium"

  def install
    system "make", "-f", "Makefile.osx"
    bin.install "reop"
  end

  test do
    system "reop"
  end
end
