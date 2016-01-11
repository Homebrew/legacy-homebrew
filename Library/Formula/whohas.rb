class Whohas < Formula
  desc "Query multiple distributions' package archives"
  homepage "http://www.philippwesche.org/200811/whohas/intro.html"
  url "http://www.philippwesche.org/200811/whohas/whohas-0.29.tar.gz"
  sha256 "4382c53ccd27f2734f5981d58baf8f3442a9eb50709d49df3629d75f802af081"

  bottle :unneeded

  def install
    bin.install "program/whohas"
    man1.install "usr/share/man/man1/whohas.1"
    (share+"whohas").install "intro.txt"
  end
end
