require "formula"

class Clib < Formula
  homepage "https://github.com/clibs/clib"
  url "https://github.com/clibs/clib/archive/1.0.0.tar.gz"
  sha1 "d840b4259190e1b3ce6cc0970f3e9f659226b9d3"

  def install
    system "make", "install"
  end

  test do
    system "clib", "-v"
  end
end
