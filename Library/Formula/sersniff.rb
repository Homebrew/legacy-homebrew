class Sersniff < Formula
  desc "Program to tunnel/sniff between 2 serial ports"
  homepage "http://www.earth.li/projectpurple/progs/sersniff.html"
  url "http://www.earth.li/projectpurple/files/sersniff-0.0.5.tar.gz"
  sha256 "8aa93f3b81030bcc6ff3935a48c1fd58baab8f964b1d5e24f0aaecbd78347209"

  head "git://the.earth.li/sersniff"

  bottle do
    cellar :any
    sha256 "ef92e5ed1bf8ebeba3d0584a7ed0b2bb9fef53947e16e4cbbf9834f43f7a23be" => :yosemite
    sha256 "40b46ca2b8bf6097f3a6f2681387627546ec4f47dc1f97acc5c84ad46a2d191a" => :mavericks
    sha256 "f7e6c501ae82d3c2291bf0bbbdde5e6e8ad6731798efb21e12b44db6ee5d39fb" => :mountain_lion
  end

  def install
    system "make"
    bin.install "sersniff"
    man8.install "sersniff.8"
  end

  test do
    assert_match(/sersniff v#{version}/,
                 shell_output("#{bin}/sersniff -h 2>&1", 1))
  end
end
