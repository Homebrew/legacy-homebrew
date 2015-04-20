class Chktex < Formula
  homepage "http://www.nongnu.org/chktex/"
  url "http://download.savannah.gnu.org/releases/chktex/chktex-1.7.2.tar.gz"
  sha256 "d7f37985e3a122990f2a29fe7cac5d1f31acb1e50035457ef7ceb07c30550158"

  depends_on :tex

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.tex").write <<-EOS.undent
      \begin{document}
        Hello world
      \end{document}
    EOS
    system bin/"chktex", "test.tex"
  end
end
