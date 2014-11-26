require "formula"

class Chinadns < Formula
  homepage "https://github.com/clowwindy/ChinaDNS-C"
  url "https://github.com/clowwindy/ChinaDNS-C/releases/download/1.1.8/chinadns-c-1.1.8.tar.gz"
  sha1 "e712aab436e555a242f6c3c8acd7474b0b445bf1"

  def install
    system "./configure"
    system "make"
    system "make install"
  end

  def caveats
    <<-EOS.undent
    Simple usage:
      sudo chinadns

    More Advanced: https://github.com/clowwindy/ChinaDNS-C#advanced
    EOS
  end
end
