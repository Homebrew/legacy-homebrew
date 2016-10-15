require "formula"

class Colloquy < Formula
  homepage "http://colloquy.info"
  url "http://colloquy.info/downloads/colloquy-latest.zip"
  sha1 "19892476af32f83685a37af16676b0098ad3bacc"
  
  depends_on :x11
  
  def install
    system "make", "install"
    prefix.install "/Applications/Colloquy.app"
  end
end

