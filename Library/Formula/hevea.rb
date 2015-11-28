class Hevea < Formula
  desc "LaTeX-to-HTML translator"
  homepage "http://hevea.inria.fr/"
  url "http://hevea.inria.fr/old/hevea-2.25.tar.gz"
  sha256 "e4c75b550bb2aa663052063d979dd1490fd7817e7cbb97b208dee92ed24ec94e"

  bottle do
    sha256 "0ffbef5c06e466891bbd0fa4dca681a3a613630bdf1cf51c5da7af434994e82c" => :el_capitan
    sha256 "2e663e23b412c82ddae6806bc48159b099016b79b5a42cfb670e1aaec3e2c634" => :yosemite
    sha256 "0fcd8481e090cbfc71ff697b46d83b32effa0983738181a8da3ecf5cf3f55272" => :mavericks
  end

  depends_on "ocaml"
  depends_on "ghostscript" => :optional

  def install
    ENV["PREFIX"] = prefix
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
