require "formula"

class Reop < Formula
  homepage "http://www.tedunangst.com/flak/post/reop"
  head 'https://github.com/tedu/reop.git', :using => :git
  url 'https://github.com/tedu/reop/archive/1.0.0.tar.gz'
  sha256 '8c2bf9a0b66e9a43cbcf3291858a97ccdc62736a378cd98aa3d3fc47f5db3798' 
  depends_on "libsodium"

  def install
    system "make", "-f", "Makefile.osx"
    bin.install "reop"
  end

  test do
    system "reop"
  end
end
