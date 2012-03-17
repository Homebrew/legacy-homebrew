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

  def caveats; <<-EOS.undent
    The authors of eff recommend installing ledit or rlwrap. The eff command
    makes use of these tools automatically.
    EOS
  end
end
