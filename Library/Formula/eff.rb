require "formula"

class Eff < Formula
  homepage "http://math.andrej.com/eff/"
  head "https://github.com/matijapretnar/eff.git", :using => :git

  depends_on "menhir"
  depends_on "objective-caml"

  def install
    system "./configure", "--prefix", prefix, "--mandir", man
    system "make"
    system "make install"
  end
end
