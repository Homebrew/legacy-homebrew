require "formula"

class LibpokerEval < Formula
  homepage "http://pokersource.sourceforge.net"
  url "http://download.gna.org/pokersource/sources/poker-eval-138.0.tar.gz"
  sha1 "b31e8731dd1cd6717002e175a00d309fc8b02781"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking"
    system "make", "install"
  end
end
