require "formula"

class Tutch < Formula
  homepage "http://www2.tcs.ifi.lmu.de/~abel/tutch/"
  url "http://www2.tcs.ifi.lmu.de/~abel/tutch/tutch-0.52-for-sml-110.45.tar.gz"
  sha1 "9fea41811fdf213351938a0495a025e3e7b508bf"

  depends_on 'smlnj'

  def install
    # the makefile will, by default, use the temporary installation
    # folder. We need it to use the Keg folder instead
    inreplace "Makefile", /"`pwd`"/, prefix
    system "make"
    bin.install "bin/tutch"
    bin.install "bin/.heap"
  end

  test do
    # Test by proving modus ponens
    (testpath/'test.tut').write(
      "proof mp: A & (A=>B) => B = 
       begin
       [A & (A=>B); A=>B; A; B ];
       A & (A=>B) => B
       end;"
    )
    system "#{bin}/tutch", 'test'
  end
end
