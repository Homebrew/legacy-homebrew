require "formula"

class Stm32flash < Formula
  homepage "https://code.google.com/p/stm32flash/"
  url "https://stm32flash.googlecode.com/files/stm32flash-0.3beta2.tar.gz"
  sha1 "ab20f3b0598a1354cc73c36b2c977ca42fa57d91"
  version "0.3beta2"
  head "git://gitorious.org/stm32flash/stm32flash.git"

  stable do
    #Create manual page folder in Makefile install target
    patch do
      url "https://gitorious.org/stm32flash/stm32flash/commit/7af2d66ad29c156176c6f62b1045cd354294b12a.diff"
      sha1 "872e15cf98e691a7ca02b5a8a0af09cfaad26881"
    end
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/stm32flash"
  end
end
