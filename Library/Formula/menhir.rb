require "formula"

class Menhir < Formula
  homepage "http://cristal.inria.fr/~fpottier/menhir/"
  url "http://cristal.inria.fr/~fpottier/menhir/menhir-20120123.tar.gz"
  md5 "1167cc6023f5d5e829e1d31ccbaad67d"

  depends_on "objective-caml"

  def install
    ENV.j1 # Avoid race condition generating parser.ml.
    system "make PREFIX=#{prefix} install"
  end
end
