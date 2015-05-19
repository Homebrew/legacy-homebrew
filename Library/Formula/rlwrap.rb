require "formula"

class Rlwrap < Formula
  desc "Readline wrapper: adds readline support to tools that lack it"
  homepage "http://utopia.knoware.nl/~hlub/rlwrap/"
  url "http://utopia.knoware.nl/~hlub/rlwrap/rlwrap-0.42.tar.gz"
  sha1 "8d2ad1be9b6c362439825ae5456a2ba5cdd7eb07"

  bottle do
    sha1 "d895f5ac3cf2db5fce06deb670c8d4877f83ec4d" => :yosemite
    sha1 "4571cde3836f4ea9c065bb35dea96cdb2f60c6ab" => :mavericks
    sha1 "fd194bd5d282e6a1a182762e7d3f89f321014713" => :mountain_lion
  end

  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
