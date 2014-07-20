require "formula"

class Menhir < Formula
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "http://cristal.inria.fr/~fpottier/menhir/menhir-20140422.tar.gz"
  sha1 "1f8980f1436f162c8abed990ade51f0e9433f7a2"

  depends_on "objective-caml"

  def install
    ENV.deparallelize
    system "make", "PREFIX=#{prefix}", "all"
    system "make", "PREFIX=#{prefix}", "install"
  end
end
