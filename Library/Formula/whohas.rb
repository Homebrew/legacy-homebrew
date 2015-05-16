require "formula"

class Whohas < Formula
  homepage "http://www.philippwesche.org/200811/whohas/intro.html"
  url "http://www.philippwesche.org/200811/whohas/whohas-0.29.tar.gz"
  sha1 "6c171275db45ab6b7f259613432e93ef879610b8"

  def install
    bin.install "program/whohas"
    man1.install "usr/share/man/man1/whohas.1"
    (share+"whohas").install "intro.txt"
  end
end
