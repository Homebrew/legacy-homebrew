class Cgterm < Formula
  desc "CGTerm is a C/G telnet client that lets you connect to C64 telnet BBS:s"
  homepage "http://paradroid.automac.se/cgterm/"
  url "http://paradroid.automac.se/cgterm/cgterm-1.6.tar.gz"
  sha256 "21b17a1f5178517c935b996d6f492dba9fca6a88bb7964f85cce8913f379a2a1"

  devel do
    url "http://paradroid.automac.se/cgterm/cgterm-1.7b2.tar.gz"
    sha256 "152bfa86d5eef0f18536968619e17ab196e624962f0d54bd255a456d7fc38cac"
  end

  depends_on "sdl"

  def install
    system "make", "install", "PREFIX=#{prefix}"

    # Default to US keyboard layout
    ln_sf "#{share}/cgterm/us.kbd", "#{share}/cgterm/keyboard.kbd"
  end
end
