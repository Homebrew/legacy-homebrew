require "formula"

class Hevea < Formula
  homepage "http://hevea.inria.fr/"
  url "http://hevea.inria.fr/distri/hevea-2.18.tar.gz"
  sha1 "1fc764a6fc946069b4ca91b29fa1e71c405265d9"

  depends_on "objective-caml"
  depends_on "ghostscript" => :optional

  def install
    inreplace "Makefile", "PREFIX=/usr/local", "PREFIX=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.tex").write <<-EOS.undent
      \\documentclass{article}
      \\begin{document}
      \\end{document}
    EOS
    system "#{bin}/hevea", "test.tex"
  end
end
